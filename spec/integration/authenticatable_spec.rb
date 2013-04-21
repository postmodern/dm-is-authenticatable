require 'spec_helper'

require 'integration/models/user'

describe DataMapper::Is::Authenticatable do
  before(:all) { User.auto_migrate! }

  let(:password) { 'secret' }

  subject { User.new(:name => 'bob') }

  it "should define the encrypted_password property" do
    subject.class.properties.should be_named(:encrypted_password)
  end

  describe "validations" do
    before { subject.password = password }

    it "should require password confirmation" do
      subject.should_not be_valid
    end

    it "should require the confirmation password match the password" do
      subject.password_confirmation = 'fail'

      subject.should_not be_valid
    end

    it "should confirmed both passwords" do
      subject.password_confirmation = password

      subject.should be_valid
    end
  end

  describe "#password" do
    it "should not have a default password" do
      subject.password.should be_nil
    end

    it "should allow setting the password" do
      subject.password = password
      subject.password.should == password
    end
  end

  describe "#password_required?" do
    context "when encrypted_password is nil" do
      before { subject.encrypted_password = nil }

      it "should return false" do
        subject.should_not be_password_required
      end
    end

    context "when encrypted_password is set" do
      before { subject.password = password }

      it "should return true" do
        subject.should be_password_required
      end
    end
  end

  describe "#has_password?" do
    before { subject.password = password }

    it "should compare the plain-text password against #encrypted_password" do
      subject.should have_password(password)
    end

    context "when #password_required? is false" do
      before { subject.stub(:password_required?).and_return(false) }

      it "should return true for nil" do
        subject.should have_password(nil)
      end

      it "should return true for ''" do
        subject.should have_password('')
      end

      it "should return false for any other String" do
        subject.should_not have_password('foo')
      end
    end
  end

  describe "#encrypted_password" do
    it "should not have an encrypted password by default" do
      subject.encrypted_password.should be_nil
    end

    it "should update the encrypted password when setting the password" do
      subject.password = password
      subject.encrypted_password.should == password
    end
  end

  describe "authenticate" do
    before(:all) do
      user = User.new(:name => 'joe')
      user.password = password
      user.save!
    end

    let(:name) { 'joe' }

    subject { User }

    it "should not allow authenticating with unknown resources" do
      user = subject.authenticate(:name => 'alice', :password => password)

      user.should be_nil
    end

    it "should allow authenticating with a password" do
      user = subject.authenticate(:name => name, :password => password)

      user.name.should == name
    end

    it "should not authenticate with an incorrect password" do
      user = subject.authenticate(:name => name, :password => 'fail')

      user.should be_nil
    end

    context "when encrypted password is nil" do
      before(:all) do
        User.first(:name => name).update(:encrypted_password => nil)
      end

      it "should allow authenticating with a nil password" do
        user = subject.authenticate(:name => name, :password => nil)

        user.name.should == name
      end

      it "should allow authenticating with an empty password" do
        user = subject.authenticate(:name => name, :password => '')

        user.name.should == name
      end

      it "should not allow authenticating with any other password" do
        user = subject.authenticate(:name => name, :password => 'foo')

        user.should be_nil
      end
    end
  end
end

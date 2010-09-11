require 'spec_helper'

require 'integration/models/user'

describe DataMapper::Is::Authenticatable do
  before(:all) do
    User.auto_migrate!
  end

  let(:password) { 'secret' }

  subject { User.new(:name => 'bob') }

  it "should define the encrypted_password property" do
    subject.class.properties.should be_named(:encrypted_password)
  end

  it "should not have a default password" do
    subject.password.should be_nil
  end

  it "should not have an encrypted password by default" do
    subject.encrypted_password.should be_nil
  end

  it "should allow setting the password" do
    subject.password = password
    subject.password.should == password
  end

  it "should update the encrypted password when setting the password" do
    subject.password = password
    subject.encrypted_password.should == password
  end

  it "should require password confirmation" do
    subject.password = password
    subject.should_not be_valid
  end

  it "should require the confirmation password match the password" do
    subject.password = password
    subject.password_confirmation = 'fail'

    subject.should_not be_valid
  end

  it "should validate confirmed passwords" do
    subject.password = password
    subject.password_confirmation = password

    subject.should be_valid
  end

  describe "authenticate" do
    before(:all) do
      user = User.new(:name => 'joe')
      user.password = password
      user.save!
    end

    let(:name) { 'joe' }

    subject { User }

    it "should allow authenticating with a password" do
      user = subject.authenticate(:name => name, :password => password)
      user.name.should == name
    end

    it "should not authenticate with an incorrect password" do
      user = subject.authenticate(:name => name, :password => 'fail')

      user.should be_nil
    end
  end
end

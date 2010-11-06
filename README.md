# dm-is-authenticatable

* [github.com/postmodern/dm-is-authenticatable](http://github.com/postmodern/dm-is-authenticatable)
* [github.com/postmodern/dm-is-authenticatable/issues](http://github.com/postmodern/dm-is-authenticatable/issues)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

A DataMapper plugin for adding authentication and encrypted passwords to
your DataMapper models. Ideal for use with
[warden](http://github.com/hassox/warden) or
[sinatra_warden](http://github.com/jsmestad/sinatra_warden).

## Example

    require 'dm-core'
    require 'dm-is-authenticatable'
  
    class User
  
      include DataMapper::Resource

      is :authenticatable
    
      # Name of the Licence
      property :name, String
    
    end
  
    user = User.new(:name => 'bob')
    user.password = 'secret'
    # => "secret"

Validates confirmation of the password:

    user.valid?
    # => false

    user.password_confirmation = 'secret'
    # => "secret"

    user.valid?
    # => true

Uses BCryptHash by default:

    user.encrypted_password
    # => "$2a$10$kC./7/ClA7mJwqqWhO02hu7//ybbsn7QKi4p5PZN0R1.XeQ/oYBAC"

Handles finding and authenticating resources in the database:

    user.save
    # => true

    User.authenticate(:name => 'bob', :password => 'secret')
    # => #<User: ...>

## Requirements

* [bcrypt-ruby](http://rubygems.org/gems/bcrypt-ruby) ~> 2.1.0
* [dm-core](http://github.com/datamapper/dm-core/) ~> 1.0.0
* [dm-types](http://github.com/datamapper/dm-types/) ~> 1.0.0
* [dm-validations](http://github.com/datamapper/dm-validations/) ~> 1.0.0

## Install

    $ sudo gem install dm-is-authenticatable

## License

See {file:LICENSE.txt} for license information.


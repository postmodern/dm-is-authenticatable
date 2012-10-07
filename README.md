# dm-is-authenticatable

* [Source](http://github.com/postmodern/dm-is-authenticatable)
* [Issues](http://github.com/postmodern/dm-is-authenticatable/issues)
* [Documentation](http://rubydoc.info/gems/dm-is-authenticatable/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

A DataMapper plugin for adding authentication and encrypted passwords to
your DataMapper models. Ideal for use with [warden], [sinatra_warden] or
[padrino-warden].

## Example

    require 'dm-core'
    require 'dm-is-authenticatable'
  
    class User
  
      include DataMapper::Resource

      is :authenticatable

      property :id, Serial
    
      # Name of the Licence
      property :name, String
    
    end
    DataMapper.finalize
  
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

Using dm-is-authenticatable with [warden]:

    Warden::Manager.serialize_into_session { |user| user.id }
    Warden::Manager.serialize_from_session { |id| User.get(id) }
    
    Warden::Strategies.add(:password) do
      def valid?
        # must specify both name and password
        params['name'] && params['password']
      end
 
      def authenticate!
        attributes = {
          :name     => params['name'],
          :password => params['password']
        }

        if (user = User.authenticate(attributes))
          success! user
        else
          fail! 'Invalid user name or password'
        end
      end
    end

## Requirements

* [bcrypt-ruby](https://github.com/codahale/bcrypt-ruby#readme) ~> 3.0, >= 2.1.0
* [dm-core](https://github.com/datamapper/dm-core#readme) ~> 1.0
* [dm-types](https://github.com/datamapper/dm-types#readme) ~> 1.0
* [dm-validations](https://github.com/datamapper/dm-validations#readme) ~> 1.0

## Install

    $ gem install dm-is-authenticatable

## License

Copyright (c) 2010-2012 Hal Brodigan

See {file:LICENSE.txt} for license information.

[warden]: https://github.com/hassox/warden#readme
[sinatra_warden]: https://github.com/jsmestad/sinatra_warden#readme
[padrino-warden]: https://github.com/jondot/padrino-warden#readme

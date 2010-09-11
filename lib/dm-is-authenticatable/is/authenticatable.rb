require 'dm-types/bcrypt_hash'
require 'dm-validations'

module DataMapper
  module Is
    module Authenticatable
      class UnknownResource < RuntimeError
      end

      def is_authenticatable
        # The encrypted password
        property :encrypted_password, DataMapper::Property::BCryptHash
    
        extend DataMapper::Is::Authenticatable::ClassMethods
        include DataMapper::Is::Authenticatable::InstanceMethods

        validates_confirmation_of :password
      end

      module ClassMethods
        #
        # Finds and authenticates a resource.
        #
        # @param [Hash] attributes
        #   The attributes to search with.
        #
        # @option attributes [String] :password
        #   The clear-text password to authenticate with.
        #
        # @return [DataMapper::Resource]
        #   The authenticated resource.
        #
        # @raise [UnknownResource]
        #   The authenticatable resource could not be found in the repository.
        #
        # @raise [ArgumentError]
        #   The `:password` option was not specified.
        #
        def authenticate(attributes)
          password = attributes.delete(:password)
          resource = self.first(attributes)

          unless resource
            raise(UnknownResource,"could not find the authenticatable resource",caller)
          end

          unless password
            raise(ArgumentError,"must specify the :password option",caller)
          end

          if resource.encrypted_password == password
            resource
          end
        end
      end

      module InstanceMethods
        # The clear-text password
        attr_reader :password

        # The confirmed clear-text password
        attr_accessor :password_confirmation

        #
        # Updates the password of the resource.
        #
        # @param [String] new_password
        #   The new password for the resource.
        #
        # @return [String]
        #   The new password of the resource.
        #
        def password=(new_password)
          self.encrypted_password = new_password
          @password = new_password
        end
      end
    end
  end
end

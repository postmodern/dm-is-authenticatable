require 'dm-types/bcrypt_hash'
require 'dm-validations'

module DataMapper
  module Is
    module Authenticatable
      class UnknownResource < RuntimeError
      end

      def is_authenticatable(options={})
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
        # @return [DataMapper::Resource, nil]
        #   The authenticated resource. If the resource could not be found,
        #   or the password did not match, `nil` will be returned.
        #
        def authenticate(attributes)
          password = attributes.delete(:password)
          resource = self.first(attributes)

          return resource if (resource && resource.has_password?(password))
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

        #
        # Determines if a password is required for authentication.
        #
        # @return [Boolean]
        #   Specifies whether a password is required or not.
        #
        # @since 0.2.0
        #
        def password_required?
          !self.encrypted_password.nil?
        end

        #
        # Determines if the submitted password matches the `encrypted_password`.
        #
        # @param [String] submitted_password
        #   The submitted password.
        #   
        # @return [Boolean]
        #   Specifies whether the submitted password matches.
        #
        # @since 0.2.0
        #
        def has_password?(submitted_password)
          !password_required? || (self.encrypted_password == submitted_password)
        end
      end
    end
  end
end

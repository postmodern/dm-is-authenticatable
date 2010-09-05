require 'dm-types/bcrypt_hash'
require 'dm-validations'

module DataMapper
  module Is
    module Authenticatable
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
        def authenticate(attributes)
          password = attributes.delete(:password)
          resource = self.first(attributes)

          if password
            return nil unless resource.encrypted_password == password
          end

          return resource
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

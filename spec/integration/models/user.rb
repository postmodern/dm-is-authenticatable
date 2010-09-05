require 'dm-core'
require 'dm-is-authenticatable'

class User

  include DataMapper::Resource

  is :authenticatable

  property :id, Serial

  property :name, String

end

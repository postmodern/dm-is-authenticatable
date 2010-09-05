require 'dm-core'
require 'dm-is-authenticatable/is/authenticatable'

DataMapper::Model.append_extensions DataMapper::Is::Authenticatable

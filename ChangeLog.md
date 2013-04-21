### 0.3.0 / 2013-04-20

* If `encrypted_password` is `nil`, have
  {DataMapper::Is::Authenticatable::InstanceMethods#has_password?} only accept
  `nil` or `""`.

### 0.2.0 / 2012-10-06

* Added {DataMapper::Is::Authenticatable::InstanceMethods#password_required?}.
* Added {DataMapper::Is::Authenticatable::InstanceMethods#has_password?}.
* {DataMapper::Is::Authenticatable::ClassMethods#authenticate}:
  * Simply return `nil` instead of raising exceptions in
  * Support authenticating models without encrypted passwords.

### 0.1.2 / 2011-10-26

* Require bcrypt-ruby ~> 3.0, >= 2.1.0.

### 0.1.1 / 2011-08-03

* Require bcrypt-ruby ~> 2.1.
* Require dm-core ~> 1.0.
* Require dm-types ~> 1.0.
* Require dm-validations ~> 1.0.

### 0.1.0 / 2010-09-04

* Initial release.


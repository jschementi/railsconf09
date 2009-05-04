require 'arinit'
require 'ardb'

# ActiveRecord Person model, to be databinded with
class Person < ActiveRecord::Base
  include ActiveRecord::AttributeChangeNotifier
end

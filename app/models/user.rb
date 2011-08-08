# The User class is not mapped and is not used in the Flex application
class User < ActiveRecord::Base
  acts_as_authentic

  has_many :blogs, :order => "created_at ASC"
end

class Post < ActiveRecord::Base

  # RubyAMF in-class mapping
  as_class 'com.rubyamf.demo.models.Post'

  map_amf :ignore_fields => [:created_at, :updated_at]

  # Here we use a scope 'show' to include the comments association. See PostsController#show. We
  # don't the comments in the Post index view. Note that if this was named :show, then comments
  # would be picked up with posts in the BlogsController#show method, which is not what we want.
  map_amf :show_comments, :include => :comments

  belongs_to :blog
  has_many :comments,
           :dependent => :destroy

  # This is here simply to demonstrate nested attributes. The current implementation
  # that creates and updates comments by saving a Post record with the comments
  # included is not the correct way to do this. You should use a CommentsController
  # and the #create and #update methods
  accepts_nested_attributes_for :comments

end

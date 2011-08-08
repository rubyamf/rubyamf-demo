class Blog < ActiveRecord::Base

  # RubyAMF in-class mapping
  as_class 'com.rubyamf.demo.models.Blog'

  map_amf :except        => [:byte_content],
          :ignore_fields => [:created_at, :updated_at]

  # Here we use a scope 'show' to return an image and include the posts association. See BlogsController#show. We
  # don't include the image or the posts in the Blog index view, so we do not return them.
  map_amf :show, :methods => :image,
                 :include => :posts,
                 :except  => :byte_content
  
  belongs_to :user
  has_many   :posts, :order => 'created_at DESC',
                     :dependent => :destroy

  # Methods that store and retrieve a ByteArray image in the database 'byte_content' field
  def image
      StringIO.new(self.byte_content) if self.byte_content && !self.byte_content.empty?
  end

  # Sets the value and escapes the string
  def image=(value)
    self.byte_content = value.string if value
  end
end

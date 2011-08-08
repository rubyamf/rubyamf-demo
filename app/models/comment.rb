class Comment < ActiveRecord::Base

  # RubyAMF in-class mapping
  as_class 'com.rubyamf.demo.models.Comment'

  # On the client, the Comment class extends AListItem, which includes the property title. We
  # ignore it here.
  map_amf :ignore_fields => [:title]

  belongs_to :post

end

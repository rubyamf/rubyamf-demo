# The UserSession class is the Authologic session class and returns a token to the Flex application with the user id.
class UserSession < Authlogic::Session::Base
  include RubyAMF::Model

  amf_class 'com.rubyamf.demo.vos.SessionToken'

  # Implements RubyAMF without processing other attributes
  def rubyamf_hash(options=nil)
    {:user_id => record.id}
  end
end

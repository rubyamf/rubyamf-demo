# The CallResult class is a wrapper for service results that allows adding a flash notice (message) to the result.
class CallResult
  include RubyAMF::Model

  amf_class 'com.rubyamf.demo.vos.CallResult'

  attr_accessor :data, :message

  def initialize data=nil, message=nil
    @data = data
    @message = message
  end
end

package com.rubyamf.demo.vos
{

[RemoteClass(alias="com.rubyamf.demo.vos.CallResult")]
/**
* The CallResult class is a value object for call results 
 * returned from the server. 
*/
public class CallResult
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CallResult() {}   
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
	//----------------------------------
	//  data
	//----------------------------------
	
	/**
	 * The data of the CallResult. 
	 */
	public var data:Object;
	
	//----------------------------------
	//  hasMessage
	//----------------------------------
	
	/**
	 * Whether the result has a message or not.
	 */
	public function get hasMessage():Boolean
	{
		return message != null && message.length > 0;
	}
	
	//----------------------------------
    //  message
    //----------------------------------
    
    /**
     * The message of the CallResult. 
     */
    public var message:String;

}

}
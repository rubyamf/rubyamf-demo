////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.models
{
[Bindable]
/**
 * The DebugMessage class converts string messages into messages that are
 * displayed in the <code>DebugConsole</code>.
 */
public class DebugMessage 
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function DebugMessage( message:String, reference:String = null ) {
        _message = message;
        _time = new Date();
        _reference = reference;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  count
    //----------------------------------
    
    /**
     * The count of the current message being displayed. Used in the 
     * <code>DebugPanel</code> to order messages with the same timestamp
     * by the order in which they are received.  
     */
    public var count:int = -1;
    
    
    //----------------------------------
    //  isEventMessage
    //----------------------------------
    
    /**
     * Whether the message is from a dispatched event or not.
     */
    public function get isEventMessage():Boolean
    {
        if ( _reference == null )
        {
            return false;
        } else {
            return _reference.toLowerCase() == "event";
        }
    }
	
    //----------------------------------
    //  message
    //----------------------------------
     
    /**
     * @private 
     * Storage for the message property. 
     */
    private var _message:String;
    
    /**
     * The original string message used to create the debug message.
     */
    public function get message():String
    {
    	return _message;
    }
    
    //----------------------------------
    //  reference
    //----------------------------------
    
    /**
     * @private
     * Storage for the reference property 
     */
    private var _reference:String;
    
    /**
     * The event reference.
     */
    public function get reference():String
    {
        return _reference;
    }
    
    //----------------------------------
    //  time
    //----------------------------------

    /**
     * @private 
     * Storage for the time property. 
     */
    private var _time:Date;
    
    /**
     * The time the <code>DebugMessage</code> was created.
     */    
    public function get time():Date
    {
        return _time;
    }
    
    //----------------------------------
    //  timeStampedMessage
    //----------------------------------
    
    /**
     * The message prepended with a time stamp in UTC milliseconds. The 
     * timestamp includes the <code>count</code> of the 
     * <code>DebugMessage</code> if it has been set. 
     */
    public function get timeStampedMessage():String 
    {
    	return timeStamp() + message;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Returns as timestamp and message of elapsed time since the last
     * message group.
     */
    public function timeLapse(lastTime:Number):String
    {
    	var time:Number = time.valueOf()
    	return timeStamp() + " Elapsed time: " 
                  + (time.valueOf() - lastTime)/1000  + " s.";
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Calculates the time stamp of the message for presentation.
     */
    private function timeStamp():String
    {
    	var countString:String;
        if (count < 10 && count != -1)
        {
           countString = "0"+ String(count);
        }
    	return "[" + time.valueOf() 
            + (countString != "" ? "-" + countString : "") + "] ";
    }
}

}
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.events
{
import flash.events.Event;

import mx.messaging.messages.IMessage;
import mx.messaging.messages.RemotingMessage;
import mx.rpc.AsyncToken;
import mx.rpc.events.ResultEvent;

/**
 * The RemoteResultEvent class extents the ResultEvent class to expose 
 * properties of the event token for convenience.
 */
public class RemoteResultEvent extends ResultEvent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function RemoteResultEvent(type:String, 
									  bubbles:Boolean=false, 
									  cancelable:Boolean=true, 
									  result:Object=null, 
									  token:AsyncToken=null, 
									  message:IMessage=null)
	{
		super(type, bubbles, cancelable, result, token, message);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  remoteMethod
	//----------------------------------
	
	/**
	 * The remote method called.
	 */
	public function get remoteMethod():String
	{
		return RemotingMessage(token.message).operation;
	}
	
	//----------------------------------
	//  remoteParameters
	//----------------------------------
	
	/**
	 * The remote parameters sent.
	 */
	public function get remoteParameters():Object
	{
		return token.message.body;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new RemoteResultEvent(type, bubbles, cancelable, result, token, 
			message);
	}
}
	
}
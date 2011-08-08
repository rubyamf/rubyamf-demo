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
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;

/**
 * The RemoteFaultEvent class extents the FaultEvent class to expose
 * properties of the event and its token for convenience.
 */
public class RemoteFaultEvent extends FaultEvent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function RemoteFaultEvent(type:String, 
									 bubbles:Boolean=false, 
									 cancelable:Boolean=true, 
									 fault:Fault=null, 
									 token:AsyncToken=null, 
									 message:IMessage=null)
	{
		super(type, bubbles, cancelable, fault, token, message);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  faultDetail
	//----------------------------------
	
	/**
	 * The fault detail.
	 */
	public function get faultDetail():String
	{
		return fault.faultDetail;
	}
	
	//----------------------------------
	//  faultString
	//----------------------------------
	
	/**
	 * The fault string.
	 */
	public function get faultString():String
	{
		return fault.faultString;
	}
	
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
		return new RemoteFaultEvent(type, bubbles, cancelable, fault, token, 
			message);
	}
}
	
}
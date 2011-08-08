////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.business
{
import com.fosrias.library.events.RemoteFaultEvent;
import com.fosrias.library.events.RemoteResultEvent;
import com.fosrias.library.interfaces.AClass;

import flash.utils.Dictionary;

import mx.rpc.AsyncToken;
import mx.rpc.Responder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.Operation;
import mx.rpc.remoting.mxml.RemoteObject;

/**
 * The RemoteService class is as wrapper class for asynchronous remote services.
 */
public class RemoteService extends AClass
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The RemoteService.CREATE constant represents a RemoteObject service 
	 * call to its create method.
	 */
	public static const CREATE:String = "create";
	
	/**
	 * The RemoteService.DESTROY constant represents a RemoteObject service 
	 * call to its destroy method.
	 */
	public static const DESTROY:String = "destroy";
	
	/**
	 * The RemoteService.EDIT constant represents a RemoteObject service 
	 * call to its edit method.
	 */
	public static const EDIT:String = "edit";
	
	/**
	 * The RemoteService.INDEX constant represents a RemoteObject service 
	 * call to its index method.
	 */
	public static const INDEX:String = "index";
	
	/**
	 * The RemoteService.SHOW constant represents a RemoteObject service 
	 * call to its show method.
	 */
	public static const SHOW:String = "show";
	
	/**
	 * The RemoteService.UPDATE constant represents a RemoteObject service 
	 * call to its update method.
	 */
	public static const UPDATE:String = "update";
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private 
	 */
	private static var pendingCallTimestamps:Dictionary = new Dictionary;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function RemoteService()
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  service
	//----------------------------------
	
	/**
	 * @private 
	 * Storage for the service property. 
	 */
	private var _service:RemoteObject;
	
	/**
	 * The remote service.
	 */
	
	public function get service():RemoteObject
	{
		return _service;
	}
	
	/**
	 * @private
	 */
	public function set service(value:RemoteObject):void
	{
		_service = value;
	}
	
	//----------------------------------
	//  service
	//----------------------------------
	
	/**
	 * Whether to show the busy cursor during remote calls or not.
	 */
	public var showBusyCursor:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Calls a remote operation on the service using an <code>AsyncToken</code>
	 * so that all response events include a token with its associated 
	 * properties including a reference to the initial arguments in the 
	 * <code>message.body</code> property of the event token.
	 * 
	 * <p>If this method is called using a single data element, it must be an
	 * array that starts with the remote operation name followed by the 
	 * parameters to be passed to the remote service.</p>
	 * 
	 * @param arguments The arguments to be passed to the remote operation.
	 */
	public function call(... args):void
	{
		//Allows event.data to be used as the sole argument in a call.
		if (args[0] is Array)
		{
			args = args[0];
		}
		
		//The first argument is always the remote method.
		var remoteOperation:String = args.shift();
		
		//Create the token
		var token:AsyncToken;
		var operation:Operation = 
			Operation( service.getOperation(remoteOperation) );
		
		operation.showBusyCursor = showBusyCursor;
		
		//Get a timestamp
		var now:Date = new Date();
		
		//Call the remote operation
		if (args.length > 0)
		{
			token = operation.send.apply(null, args);
			
		}  else {
			
			token = operation.send();
		} 
		
		//Set the token responder
		token.addResponder( new Responder(onResult, onFault) );
		
		//Store the time for reference
		pendingCallTimestamps[token] = now;
		
		//Display debug message
		traceDebug( className + "." + remoteOperation + " called.");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Finds the cached timestamp associated with a remote service call
	 * token.
	 * 
	 * @param date The current time to compare with the cached time.
	 * @param token The remote service token.
	 */
	protected function findTimestamp(date:Date, token:AsyncToken):String
	{
		var timestamp:Date = pendingCallTimestamps[token]; 
		
		//Clear dictionary reference
		pendingCallTimestamps[token] = null;
		delete pendingCallTimestamps[token];
		
		return ( (date.getTime() - timestamp.getTime() )/1000).toString() 
			+ " s"; 
	}
	
	/**
	 * Handler for remote service call faults.
	 * 
	 * @param event The fault of the service call.
	 */
	protected function onFault(event:FaultEvent):void 
	{
		//Get a timestamp
		var now:Date = new Date();
		
		var newFaultEvent:RemoteFaultEvent = new RemoteFaultEvent(event.type, 
			event.bubbles, event.cancelable, event.fault, event.token, 
			event.message);
		
		traceDebug("Fault: " + newFaultEvent.message + " returned "
			+ " in " + findTimestamp(now, event.token) + " .");
		
		dispatchEvent(newFaultEvent);
	}
	
	/**
	 * Handler for remote service call results.
	 * 
	 * @param event The result event.
	 */
	protected function onResult(event:ResultEvent):void 
	{
		//Get a timestamp
		var now:Date = new Date();
		
		var newResultEvent:RemoteResultEvent = new RemoteResultEvent(event.type, 
			event.bubbles, event.cancelable, event.result, event.token, 
			event.message);
		
		//Rebroadcast the result
		dispatchEvent(newResultEvent);
		
		var resultString:String = "Null";
		
		if (newResultEvent.result != null)
			resultString = newResultEvent.result.toString()
				
		traceDebug("Result: " + resultString + " returned "
			+ " in " + findTimestamp(now, newResultEvent.token) + " ."); 
	}
}

}
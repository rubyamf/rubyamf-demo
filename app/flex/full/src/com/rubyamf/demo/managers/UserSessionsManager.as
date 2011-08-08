////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.managers
{
import com.fosrias.library.business.RemoteService;
import com.rubyamf.demo.events.PayloadEvent;
import com.fosrias.library.events.RemoteFaultEvent;
import com.fosrias.library.events.RemoteResultEvent;
import com.fosrias.library.managers.interfaces.AManager;
import com.rubyamf.demo.vos.CallResult;
import com.rubyamf.demo.vos.SessionToken;

import mx.controls.Alert;

/**
 * The UserSessionsManager is the controller for the <code>SessionUI</code>
 * view.
 */
public class UserSessionsManager extends AManager
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function UserSessionsManager()
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for view model execute event.
	 */
	public function execute(event:PayloadEvent):void
	{
		event.stopImmediatePropagation();
		
		if (hasPendingRemoteCall)
			return;
		
		if (event.data != null)
		{
			var token:SessionToken = event.data as SessionToken;
			
			if (token.hasCredentials)
			{
				//The set the credentials on the injected service RemoteObject.
				service.setRemoteCredentials(token.login, token.password);
				remoteCall(RemoteService.CREATE);
				
			} else {
				
				showCenteredAlert("You must provide both a Login and Password.", 
					"Login Error");
			}
				
		} else if (hasSession) {
			
			remoteCall(RemoteService.DESTROY);
			
		} else {
			
			//Close or open the SessionUI
			setVisible(!modelVisible);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for remote faults.
	 */
	override public function callFault(event:RemoteFaultEvent):*
	{
		super.callFault(event);
		
		if (event.remoteMethod == RemoteService.CREATE)
			Alert.show(event.faultString, "Login Error");
	}
	
	/**
	 * Handler for remote service call to create a session.
	 */
	override public function callResult(event:RemoteResultEvent):*
	{
		super.callResult(event);
		
		var result:CallResult = event.result as CallResult;
		
		//Process the result based on the type call
		switch (event.remoteMethod)
		{
			case RemoteService.CREATE:
			{
				//We pass back a token with the user id in it for reference
				_sessionsManager.token = result.data as SessionToken;
				
				//Clear the credentials since they are only used for creating 
				//a session
				service.setRemoteCredentials(null, null);
				
				setVisible(false);
				break;
			}
			case RemoteService.DESTROY:
			{
				//End the session. This triggers the sessionEndHook callbacks 
				//in all subclasses of AClass
				if (result.data === true)
					_sessionsManager.endSession();
				break;
			}
			case RemoteService.SHOW:
			{
				//Here we check if an existing session exists. Affects 
				//refreshing the browser during a session.
				
				//We pass back a token with the user id in it for reference
				_sessionsManager.token = result.data as SessionToken;

				setVisible(false);
				break;
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function remoteCall(action:String):void
	{
		dispatchEvent( new PayloadEvent(PayloadEvent.CALL, [action], null, 
			false) );
	}
}
	
}
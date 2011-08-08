////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.managers
{
import com.rubyamf.demo.vos.SessionToken;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

[Bindable]  
/**
 * The SessionUserManager class is a singleton aggregate class that maintains 
 * the session state and notifies subclasses if the session state changes that 
 * listen for a <code>SessionManager.SESSION_CHANGE</code> event. Classes that
 * extend the abstract class AClass can use the hook method 
 * <code>sessionChangeHook</code> to manage session changes.
 */
public class SessionsManager extends EventDispatcher 
{     
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The constant representing a session change event.
	 */
	public static const SESSION_CHANGE:String = "sessionChange";
	
	/**
	 * The constant the time before a session times out. The default is 
	 * 15 minutes.
	 */
	public static const TIMEOUT_DELAY:uint = 900000;
	
	/**
	 * @private 
	 */
	private static const _instance:SessionsManager 
		= new SessionsManager(SingletonEnforcer);  
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/** 
	 * Constructor 
	 *  
	 * @param enforcer The Singleton enforcer class to prevent outside 
	 * instantiation. 
	 */  
	public function SessionsManager(enforcer:Class)  
	{  
		// Verify that the lock is the correct class reference.  
		if (enforcer != SingletonEnforcer)  
		{  
			throw new Error( "Invalid Singleton access. " +
				"Use SessionManager.getInstance()." );  
		}  
	}  
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/** 
	 * @private
	 */  
	private var _hasSessionTimeout:Boolean = false;
	
	/** 
	 * @private
	 */  
	private var _sessionIndex:uint;
	
	/** 
	 * @private
	 */  
	private var _timeoutDelay:uint = TIMEOUT_DELAY;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  hasSession
	//----------------------------------
	
	/**
	 * Whether a current session exists.
	 */
	public function get hasSession():Boolean
	{
		return _token.hasSession;
	}
	
	//----------------------------------
	//  login
	//----------------------------------
	
	/**
	 * The login of the current token.
	 */
	public function get login():String
	{
		return _token.login;
	}
	
	//----------------------------------
	//  password
	//----------------------------------
	
	/**
	 * The password of the current token.
	 */
	public function get password():String
	{
		return _token.login;
	}
	
	//----------------------------------
	//  token
	//----------------------------------
	
	/**
	 * @private
	 * Storage of the token property.
	 */
	private var _token:SessionToken = new SessionToken();
	
	/**
	 * The session user.
	 */
	public function get token():SessionToken
	{
		return _token;
	}
	
	/**
	 * @private
	 */
	public function set token(value:SessionToken):void
	{
		if (value != null)
		{
			_token = value;
			
		} else {
			
			_token = new SessionToken;
		}
		
		//If there is a valid session, set the timeout
		if (_token.hasSession)
		{
			resetSessionTimeout();
			
		} else {
			
			//Cancel any pending timeout
			clearTimeout(_sessionIndex);
		}
		
		dispatchEvent( new Event(SESSION_CHANGE) );
	}
	
	//----------------------------------
	//  userId
	//----------------------------------
	
	/**
	 * The current user id.
	 */
	public function get userId():uint
	{
		return _token.userId;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Enables session timeout. If a delay is not specified, it uses the 
	 * default of 15 minutes.
	 */
	public function enableSessionTimeout(delay:Number = NaN):void
	{
		_hasSessionTimeout = true;
		
		//Override the default
		if ( !isNaN(delay) )
			_timeoutDelay = delay;
	}
	
	/**
	 * Resets the session timeout.
	 */
	public function endSession():void
	{
		token = new SessionToken();
	}
	
	/**
	 * Resets the session timeout.
	 */
	public function resetSessionTimeout():void
	{
		if (_hasSessionTimeout && _token.hasSession)
		{
			clearTimeout(_sessionIndex);
			_sessionIndex = setTimeout(endSession, _timeoutDelay);
		}
	}
	
	/**
	 * Sets a pending token so that remote calls have a login and password 
	 * defined for creating sessions.
	 */
	public function setPendingToken(value:SessionToken):void
	{
		_token = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	/** 
	 * Provides singleton access to the instance. 
	 */  
	public static function getInstance():SessionsManager  
	{  
		return _instance;  
	}     
}
	
} 

/**
 * This is a private class declared outside of the package 
 * that is only accessible to classes inside of the SessionManager.as 
 * file. Because of that, no outside code is able to get a 
 * reference to this class to pass to the constructor, which 
 * enables us to prevent outside instantiation. 
 */  
class SingletonEnforcer {}
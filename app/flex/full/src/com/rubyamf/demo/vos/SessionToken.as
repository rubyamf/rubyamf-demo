////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.vos
{

[RemoteClass (alias="com.rubyamf.demo.vos.SessionToken")]
/**
 * The SessionToken class is a value object that stores information on the 
 * current session and the session user.
 */	
public class SessionToken
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SessionToken(login:String = null, 
								 password:String = null,
							     rememberMe:Boolean = false)
	{
		_login = login;
		_password = password;
		_rememberMe = rememberMe;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  hasCredentials
	//----------------------------------
	
	/**
	 * Whether the token has valid creditials set or not. Returns false if
	 * if neither the login or password have been set on the token.
	 */
	public function get hasCredentials():Boolean
	{
		return _login != null &&  _password != null && 
			_login != "" &&  _password != "";
	}
	
	//----------------------------------
	//  hasSession
	//----------------------------------
	
	/**
	 * Whether the token corresponds to a valid session or not.
	 */
	public function get hasSession():Boolean
	{
		return userId != 0;
	}
	
	//----------------------------------
	//  login
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the login property.
	 */
	private var _login:String;

	/**
	 * The login name.
	 */
	public function get login():String
	{
		return _login;
	}

	//----------------------------------
	//  password
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the login property.
	 */
	private var _password:String;

	/**
	 * The user password.
	 */
	public function get password():String
	{
		return _password;
	}

	//----------------------------------
	//  rememberMe
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the rememberMe property.
	 */
	private var _rememberMe:Boolean;

	/**
	 * Whether the user should be remembered.
	 */
	public function get rememberMe():Boolean
	{
		return _rememberMe;
	}

	//----------------------------------
	//  userId
	//----------------------------------
	
	/**
	 * The id of the user that has the session.
	 */
	public var userId:uint;
}
	
}
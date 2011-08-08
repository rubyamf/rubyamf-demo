////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.events
{

/**
 * The PayloadEventKind specifies event kinds for PayloadEvent instances.
 */
public class PayloadEventKind
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The PayloadEvent.CANCEL constant is a type of PayloadEvent that
	 * represents an event associated with a cancel kind.
	 */
	public static const CANCEL:String = "cancel";
	
	/**
	 * The PayloadEvent.CREATE constant is a type of PayloadEvent that
	 * represents an event associated with a create kind.
	 */
	public static const CREATE:String = "create";
	
	/**
	 * The PayloadEvent.DELETE constant is a type of PayloadEvent that
	 * represents an event associated with a delete kind.
	 */
	public static const DELETE:String = "delete";
	
	/**
	 * The PayloadEvent.EDIT constant is a type of PayloadEvent that
	 * represents an event associated with a edit kind.
	 */
	public static const EDIT:String = "edit";
	
	/**
	 * The PayloadEvent.LINK constant is a type of PayloadEvent that
	 * represents an event associated with a link kind.
	 */
	public static const LINK:String = "link";
	
	/**
	 * The PayloadEvent.LOAD constant is a type of PayloadEvent that
	 * represents an event associated with a load kind.
	 */
	public static const LOAD:String = "load";
	
	/**
	 * The PayloadEvent.SAVE constant is a type of PayloadEvent that
	 * represents an event associated with a save kind.
	 */
	public static const SAVE:String = "save";
	
	/**
	 * The PayloadEvent.SHOW constant is a type of PayloadEvent that
	 * represents an event associated with a show kind.
	 */
	public static const SHOW:String = "show";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function PayloadEventKind() {}
}
	
}
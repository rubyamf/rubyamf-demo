////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.views.models.interfaces
{
import com.fosrias.library.interfaces.AClass;
import com.rubyamf.demo.events.PayloadEvent;

import flash.errors.IllegalOperationError;
import flash.events.Event;

[Bindable]
/**
 * The AViewModel class is the base class for presentation view models.
 */
public class AViewModel extends AClass
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function AViewModel(self:AClass)
	{
		super(self);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Injected properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  action
	//----------------------------------
	
	/**
	 * Action occuring the underlying record.
	 */
	public var action:String;
	
	//----------------------------------
	//  hasEditLock
	//----------------------------------
	
	/**
	 * Whether the application has an edit lock or not.
	 */
	public var hasEditLock:Boolean;
	
	//----------------------------------
	//  isDirty
	//----------------------------------
	
	/**
	 * Whether the underlying view record is dirty or not.
	 */
	public var isDirty:Boolean;
	
	//----------------------------------
	//  visible
	//----------------------------------
	
	/**
	 * Whether the view is visible or not.
	 */
	public var visible:Boolean;
	
	//----------------------------------
	//  viewIndex
	//----------------------------------
	
	/**
	 * The index of a viewstack in the view.
	 */
	public var viewIndex:uint;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Filter function that determines if an item is editable or not.
	 */
	public function editableFilter(item:Object):Boolean
	{
		throw new IllegalOperationError("Abstract method 'editableFilter' " +
			"must be overridden in " + className);
	}
	
	/**
	 * Utility method to report something executed in the view.
	 */
	public function execute(data:Object=null, message:String=null,
		triggeringEvent:Event = null, bubbles:Boolean = false):void
	{
		dispatchEvent( new PayloadEvent(PayloadEvent.EXECUTE, data, message, 
			bubbles, triggeringEvent) );
	}
	
	/**
	 * Utility method to report something has changed in the view.
	 */
	public function setDirty(data:Object=null, message:String=null):void
	{
		dispatchEvent( new PayloadEvent(PayloadEvent.DIRTY, data, message, 
			false ) );
	}
}
	
}
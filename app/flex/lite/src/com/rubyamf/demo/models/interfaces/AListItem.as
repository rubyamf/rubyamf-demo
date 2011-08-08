////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.models.interfaces
{
import flash.events.EventDispatcher;

[Bindable]
/**
 * The AListItem class is the base class for Blogs and classses that 
 * share common list related properties.
 */
public class AListItem extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function AListItem(id:uint = 0,
							  title:String = null, 
							  detail:String = null)
	{
		super(this);
		
		this.id = id;
		this.detail = detail;
		this.title = title;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  createdAt
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the createdAt property.
	 */
	private var _createdAt:Date;
	
	[Transient]
	/**
	 * The date the record was created.
	 */
	public function get createdAt():Date
	{
		return _createdAt;
	}

	/**
	 * @private
	 */
	public function set createdAt(value:Date):void
	{
		_createdAt = adjustFromRemoteTimeZone(value);
	}

	//----------------------------------
	//  id
	//----------------------------------
	
	/**
	 * The id.
	 */
	public var id:uint;
	
	//----------------------------------
	//  isNew
	//----------------------------------
	
	/**
	 * Whether the blog is a new record or not.
	 */
	public function get isNew():Boolean
	{
		return id == 0;
	}
	
	//----------------------------------
	//  detail
	//----------------------------------
	
	/**
	 * The description of the blog.
	 */
	public var detail:String;
	
	//----------------------------------
	//  title
	//----------------------------------
	
	/**
	 * The title. 
	 */
	public var title:String;
	
	//----------------------------------
	//  updatedAt
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the updatedAt property.
	 */
	private var _updatedAt:Date;

	[Transient]
	/**
	 * The date the record was last updated.
	 */
	public function get updatedAt():Date
	{
		return _updatedAt;
	}

	/**
	 * @private
	 */
	public function set updatedAt(value:Date):void
	{
		_updatedAt = adjustFromRemoteTimeZone(value);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * 
	 * Adjusts dates for remote returns.
	 * 
	 * @see http://flexblog.faratasystems.com/2008/02/05/flex-local-datestime-transfer-issue
	 */	
	private function adjustFromRemoteTimeZone(date:Date):Date
	{
		if (date == null)
			return null;
		
		return new Date(date.valueOf() + date.getTimezoneOffset() * 60000);
	}
}
	
}
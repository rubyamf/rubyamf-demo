////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.models
{
import com.rubyamf.demo.models.interfaces.AListItem;

[Bindable]
[RemoteClass(alias="com.rubyamf.demo.models.Comment")]
/**
 * The Comment class is the model for comments.
 */
public class Comment extends AListItem
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function Comment(id:int = 0, 
							name:String = null, 
							email:String = null, 
							website:String = null,
							detail:String = null)
	{
		super(id, null, detail);
		this.name = name;
		this.email = email;
		this.website = website;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  email
	//----------------------------------
	
	/**
	 * The email address of the commenter.
	 */
	public var email:String;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The name of the commenter.
	 */
	public var name:String;
	
	//----------------------------------
	//  postId
	//----------------------------------
	
	/**
	 * The associated post's id.
	 */
	public var postId:int;
	
	//----------------------------------
	//  website
	//----------------------------------
	
	/**
	 * The website of the commenter.
	 */
	public var website:String;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function isEqual(value:Object):Boolean
	{
		var isEqual:Boolean = super.isEqual(value)
		
		if (isEqual)
		{
			isEqual &&= value.email == email &&
				        value.website == website;
			
			return isEqual;
		}
		return false;
	}
}
	
}
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

import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.rubyamf.demo.models.Post")]
/**
 * The Post class is the model for posts.
 */
public class Post extends AListItem
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function Post(id:int = 0,
	                     title:String = null,
					     detail:String = null)
	{
		super(id, title, detail);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  blogId
	//----------------------------------
	
	/**
	 * The associated blog id.
	 */
	public var blogId:int;
	
	//----------------------------------
	//  clone
	//----------------------------------
	
	[Transient]
	/**
	 * A clone of the instance.
	 */
	public function get clone():Post
	{
		var clone:Post  = new Post(id, title, detail);
		clone.blogId = blogId;
		
		// Not fully implemented. Should clone elements.
		clone.comments = new ArrayCollection(comments.source);
		
		return clone;
	}
	
	//----------------------------------
	//  comments
	//----------------------------------
	
	/**
	 * The comments of the post.
	 */
	public var comments:ArrayCollection = new ArrayCollection();
}
	
}
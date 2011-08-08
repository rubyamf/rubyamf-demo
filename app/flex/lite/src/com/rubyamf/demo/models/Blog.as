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

import flash.utils.ByteArray;

import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.rubyamf.demo.models.Blog")]
/**
 * The Blog class is the model for blogs.
 */
public class Blog extends AListItem
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function Blog(id:uint = 0,
						 author:String = null,
						 bio:String = null,
						 detail:String = null,
						 tagline:String = null,
						 title:String = null,
						 image:ByteArray = null) 
	{
		super(id, title, detail);
		
		this.author = author;
		this.bio = bio;
		this.image = image;
		this.tagline = tagline;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  author
	//----------------------------------
	
	/**
	 * The author's name.
	 */
	public var author:String;
	
	//----------------------------------
	//  bio
	//----------------------------------
	
	/**
	 * The author's biography.
	 */
	public var bio:String;
	
	//----------------------------------
	//  clone
	//----------------------------------
	
	[Transient]
	/**
	 * A clone of the model.
	 */
	public function get clone():Blog
	{
		var clone:Blog = new Blog(id, author, bio, detail, tagline, title, 
			image);
		
		// Not fully implemented. Should clone elements.
		clone.posts = new ArrayCollection(posts.source);
		
		clone.userId = userId;
		return clone;
	}
	
	//----------------------------------
	//  image
	//----------------------------------
	
	/**
	 * The image of the author.
	 */
	public var image:ByteArray;
	
	//----------------------------------
	//  posts
	//----------------------------------
	
	[Transient]
	/**
	 * The blog posts.
	 */
	public var posts:ArrayCollection = new ArrayCollection();
	
	//----------------------------------
	//  tagline
	//----------------------------------
	
	/**
	 * The tagline of the blog.
	 */
	public var tagline:String;

	//----------------------------------
	//  userId
	//----------------------------------
	
	[Transient]
	/**
	 * The user id of the blog.
	 */
	public var userId:int;
}
	
}
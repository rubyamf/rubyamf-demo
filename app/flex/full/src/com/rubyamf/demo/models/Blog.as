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
import com.fosrias.library.models.interfaces.IIsEqual;
import com.rubyamf.demo.models.interfaces.AListItem;
import com.rubyamf.demo.models.interfaces.IMemento;

import flash.events.EventDispatcher;
import flash.utils.ByteArray;

import flashx.textLayout.formats.BlockProgression;

import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.rubyamf.demo.models.Blog")]
/**
 * The Blog class is the model for blogs.
 */
public class Blog extends AListItem implements IIsEqual
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
		
		//Not fully implemented. Should clone elements also.
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
		var isEqual:Boolean = value is Blog && super.isEqual(value);
		
		if (isEqual)
		{
			isEqual &&= value.author == author &&
						value.bio == bio &&
						value.image == image &&
						value.tagline == tagline;
			
			return isEqual;
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function restore(memento:IMemento):void
	{
		super.restore(memento);
		
		if (memento is Blog)
		{
			var mementoItem:Blog = memento as Blog;
			
			author = mementoItem.author;
			bio = mementoItem.title;
			image = mementoItem.image;
			posts = mementoItem.posts;
			tagline = mementoItem.tagline;
			userId = mementoItem.userId;
		}
		
	}
}
	
}
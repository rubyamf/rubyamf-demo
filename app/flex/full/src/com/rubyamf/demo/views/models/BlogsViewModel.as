////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.views.models
{
import com.fosrias.library.views.models.interfaces.AViewModel;
import com.rubyamf.demo.models.Blog;

import mx.collections.ArrayCollection;

[Bindable]
/**
 * The BlogsViewModel class is the presentation model for the Blogs UI view.
 */
public class BlogsViewModel extends AViewModel
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function BlogsViewModel()
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	/**
	 * @private
	 * The image if none is specified.
	 */
	[Embed(source='assets/images/placeholder.jpg')]
	private var _img:Class;
	
	//--------------------------------------------------------------------------
	//
	//  Injected properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  blogs
	//----------------------------------
	
	/**
	 * The blogs to display.
	 */
	public var blogs:ArrayCollection;
	
	//----------------------------------
	//  selectedBlog
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the selectedBlog property.
	 */
	private var _selectedBlog:Blog;

	/**
	 * The selected blog to display.
	 */
	public function get selectedBlog():Blog
	{
		return _selectedBlog;
	}

	/**
	 * @private
	 */
	public function set selectedBlog(value:Blog):void
	{
		_selectedBlog = value;
		dispatchEventType("blogChange");
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	[Bindable("blogChange")]
	/**
	 * The tool tip shown on the blog edit button.
	 */
	public function get deleteToolTip():String
	{
		if (_selectedBlog == null)
			return null;
		
		return 'Delete ' + _selectedBlog.title;
	}
	
	[Bindable("blogChange")]
	/**
	 * The tool tip shown on the blog edit button.
	 */
	public function get editToolTip():String
	{
		if (_selectedBlog == null)
			return null;
		
		return 'Edit ' + _selectedBlog.title;
	}
	
	[Bindable("blogChange")]
	/**
	 * The image of the author.
	 */
	public function get image():Object
	{
		//Set an image for the blog.
		if (_selectedBlog != null && _selectedBlog.image != null)
				return _selectedBlog.image;
		
		return _img;
	}
	
	[Bindable("blogChange")]
	[Bindable("sessionChange")]
	/**
	 * Whether the selected blog is editable or not.
	 */
	public function get isEditable():Boolean
	{
		return editableFilter(_selectedBlog);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function editableFilter(item:Object):Boolean
	{
		return hasSession && item != null && Blog(item).userId == userId;
	}
}
	
}
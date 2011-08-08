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
import com.fosrias.library.interfaces.AClass;
import com.fosrias.library.views.models.interfaces.AViewModel;
import com.rubyamf.demo.models.Post;

import mx.collections.ArrayCollection;

[Bindable]
/**
 * The PostsViewModel is the presentation view model of the post related views
 * and components.
 */
public class PostsViewModel extends AViewModel
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function PostsViewModel()
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Injected properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isEditable
	//----------------------------------
	
	/**
	 * Whether the posts in the view are editable or not.
	 */
	public var isEditable:Boolean;
	
	//----------------------------------
	//  posts
	//----------------------------------
	
	/**
	 * The view posts.
	 */
	public var posts:ArrayCollection;
	
	//----------------------------------
	//  selectedPost
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the selectedPost property
	 */
	private var _selectedPost:Post;

	/**
	 * The selected post.
	 */
	public function get selectedPost():Post
	{
		return _selectedPost;
	}

	/**
	 * @private
	 */
	public function set selectedPost(value:Post):void
	{
		_selectedPost = value;
		dispatchEventType("postChange");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	[Bindable("postChange")]
	/**
	 * The tool tip shown on the post edit button.
	 */
	public function get deleteToolTip():String
	{
		if (_selectedPost == null)
			return null;
		
		return 'Delete ' + _selectedPost.title;
	}
	
	[Bindable("postChange")]
	/**
	 * The tool tip shown on the post edit button.
	 */
	public function get editToolTip():String
	{
		if (_selectedPost == null)
			return null;
		
		return 'Edit ' + _selectedPost.title;
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
		return isEditable;
	}
}

}
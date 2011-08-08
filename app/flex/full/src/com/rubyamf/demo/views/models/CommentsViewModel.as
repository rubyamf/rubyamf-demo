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
import com.rubyamf.demo.models.Blog;
import com.rubyamf.demo.models.Post;

import mx.collections.ArrayCollection;

[Bindable]
/**
 * The CommentsViewModel class is the presentation view model for the
 * <code>CommentsUI</code> view.
 */
public class CommentsViewModel extends AViewModel
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function CommentsViewModel()
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Injected properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  selectedBlog
	//----------------------------------
	
	/**
	 * The currently selected blog.
	 */
	public var selectedBlog:Blog;
	
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
		
		if (_selectedPost != null)
		{
			comments = _selectedPost.comments;
		} else {
			
			comments = new ArrayCollection();
		}
	}
	
	//----------------------------------
	//  comments
	//----------------------------------
	
	/**
	 * The comments associated with the selected post.
	 */
	public var comments:ArrayCollection;
	
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
		return hasSession && selectedBlog != null && 
			selectedBlog.userId == userId;
	}
}
	
}
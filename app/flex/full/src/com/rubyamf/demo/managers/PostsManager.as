////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.rubyamf.demo.managers
{
import com.fosrias.library.business.RemoteService;
import com.fosrias.library.events.RemoteFaultEvent;
import com.fosrias.library.events.RemoteResultEvent;
import com.fosrias.library.managers.interfaces.AManager;
import com.rubyamf.demo.events.PayloadEvent;
import com.rubyamf.demo.events.PayloadEventKind;
import com.rubyamf.demo.models.Blog;
import com.rubyamf.demo.models.Comment;
import com.rubyamf.demo.models.Post;
import com.rubyamf.demo.models.interfaces.AListItem;
import com.rubyamf.demo.vos.CallResult;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.PropertyChangeEvent;

public class PostsManager extends AManager
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function PostsManager()
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
	 */
	private var _pendingAction:String;
	
	/**
	 * @private
	 */
	private var _pendingPost:Post;
	
	/**
	 * @private
	 */
	private var _selectedBlog:Blog;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  modelIsDirty
	//----------------------------------
	
	[Bindable("dirtyChange")]
	/**
	 * Whether the blog has been edited or not.
	 */
	public function get modelIsDirty():Boolean
	{
		return _pendingPost != null && 
			!_pendingPost.isEqual(_modelSelectedPost);
	}
	
	//----------------------------------
	//  modelIsEditable
	//----------------------------------
	
	[Bindable("postsChange")]
	[Bindable("sessionChange")]
	/**
	 * Whether the selected blog (and its posts) is editable or not.
	 */
	public function get modelIsEditable():Boolean
	{
		return hasSession && _selectedBlog != null &&
			_selectedBlog.userId == userId;
	}
	
	//----------------------------------
	//  modelPosts
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelPosts property.
	 */
	private var _modelPosts:ArrayCollection = new ArrayCollection();
	
	[Bindable("postsChange")]
	/**
	 * The posts associated with the current blog.
	 */
	public function get modelPosts():ArrayCollection
	{
		return _modelPosts;
	}
	
	//----------------------------------
	//  modelSelectedPost
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelSelectedPost property.
	 */
	private var _modelSelectedPost:Post;
	
	[Bindable("selectedPostChange")]
	/**
	 * The currently selected blog to display.
	 */
	public function get modelSelectedPost():Post
	{
		return _modelSelectedPost;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for PayloadEvent.EXECUTE.
	 */
	public function execute(event:PayloadEvent):void
	{
		var post:Post;
		
		switch (event.kind)
		{
			case PayloadEventKind.CANCEL:
			{
				//Clear the edits
				cancelEditing();
				break;
			}
			case PayloadEventKind.CREATE:
			{
				setAction("Create Post");
				
				//We don't report this since we are not moving off the
				//BlogsUI when creating a post. This prevents breadcrumbs
				//from getting out of sync.
				setSelectedPost(new Post(), false);
				reportEditing();
				break;
			}
			case PayloadEventKind.DELETE:
			{
				_pendingPost = event.data as Post;
				
				showCenteredAlert("Are you sure you want to delete\nthe Post " +
					"'" + _pendingPost.title + "'?", 
					"Confirm Delete", Alert.OK | Alert.CANCEL, 
					event.target as Sprite, deletePostHandler, 
					event.triggeringEvent as MouseEvent);
				break;
			}
			case PayloadEventKind.EDIT:
			{
				if (_modelSelectedPost == event.data)
				{
					setAction("Edit Post");
					reportEditing();
					
				} else {
					
					_pendingAction = "Edit Post";
					
					post = event.data as Post;
					
					//Load the blog from the remote service to pick up 
					//scoped attributes of the blog.
					remoteCall(RemoteService.SHOW, post.id);
				}
				break;
			}
			case PayloadEventKind.SAVE:
			{
				var remoteAction:String;
				
				if (event.data == null)
				{
					if (_modelSelectedPost.isNew)
					{
						remoteAction = RemoteService.CREATE;
						
					} else {
						
						remoteAction = RemoteService.UPDATE;
					}
				} else {
					
					//We are saving a comment. This in not the correct way to
					//do this. It is only done as an example of setting
					//nested attributes in the Post model on the server.
					_modelSelectedPost.comments.addItem(event.data);
					
					//Stop the event from continuing to bubble to the 
					//BlogsManager
					event.stopImmediatePropagation();
				}
				remoteCall(remoteAction, _modelSelectedPost);
				
				//Clear the editing mode
				setAction(null);
				break;
			}
			case PayloadEventKind.SHOW:
			{
				post = event.data as Post;
				
				//Load the post from the remote service to pick up 
				//scoped attributes (comments).
				remoteCall(RemoteService.SHOW, post.id);
				break;
			}
		}
	}
	
	/**
	 * Handler for the PayloadEvent.SHOW_BLOG event.
	 */
	public function showBlog(event:PayloadEvent):void
	{
		_selectedBlog = event.data as Blog;
		setViewIndex(0);
		
		if (_selectedBlog != null)
		{
			_modelPosts = _selectedBlog.posts;
			
		} else {
			
			_modelPosts = new ArrayCollection();
		}
		dispatchEventType("postsChange");
	}
	
	/**
	 * Handler that resets the view to show PostsUI index view.
	 */
	public function showPost(event:PayloadEvent):void
	{
		if (event.kind == PayloadEventKind.CANCEL)
			setViewIndex(0);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for remote faults.
	 */
	override public function callFault(event:RemoteFaultEvent):*
	{
		super.callFault(event);
	}
	
	/**
	 * Handler for remote service call to create a session.
	 */
	override public function callResult(event:RemoteResultEvent):*
	{
		// Handles flash notices and cancels the method if in live demo
		// mode by setting LIVE_DEMO = true in ApplicationController.rb
		if ( !super.callResult(event) )
			return;
		
		var result:CallResult = event.result as CallResult;
		
		//Process the result based on the type call
		switch (event.remoteMethod)
		{
			case RemoteService.CREATE:
			{
				//Add at the front per remote order
				_modelPosts.addItemAt(result.data, 0);
				
				reportEditing(false);
				break;
			}
			case RemoteService.DESTROY:
			{
				if (result.data == true)
				{
					_modelPosts = replaceItem(_modelPosts, 
						_modelSelectedPost, null);
				    
				    //Replace the updated posts in the blog
				    _selectedBlog.posts = _modelPosts;
				}
				break;
			}
			case RemoteService.INDEX:
			{
				_modelPosts = result.data as ArrayCollection;
				break;
			}
			case RemoteService.SHOW:
			{
				setSelectedPost(result.data as Post);
				
				if (_pendingAction != null)
				{
					setAction(_pendingAction);
					_pendingAction = null;
					reportEditing();
				}
				
				//Show the post and its comments.
				setViewIndex(1);
				break;
			}
			case RemoteService.UPDATE:
			{
				//We replace the item in the Blogs collection so that we don't 
				//have to reload it.
				_modelPosts = replaceItem(_modelPosts, 
					_modelSelectedPost, result.data as AListItem);
				
				//We update the currently selected blog with the remote changes
				setSelectedPost(result.data as Post);
				reportEditing(false);
				break;
			}
		}
		dispatchEventType("postsChange");
	}
	
	/**
	 * @inheritDoc
	 */
	override protected function sessionChangeHook():void
	{
		//If we logout while editing, we cancel edits.
		cancelEditing();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function cancelEditing():void
	{
		setAction(null);
		
		//Only reset it if the model is dirty
		if (modelIsDirty)
			_modelSelectedPost.restore(_pendingPost);
		
		reportEditing(false);
	}
	
	/**
	 * @private
	 */
	private function deletePostHandler(event:CloseEvent):void
	{
		if (event.detail == Alert.OK)
			remoteCall(RemoteService.DESTROY, _pendingPost.id);
		
		//Reset the pending blog
		setSelectedPost(_pendingPost);
	}
	
	/**
	 * @private
	 */
	private function remoteCall(action:String, value:Object):void
	{
		//Cancel bubbling so the BlogsLocalEventMap does not hear the event.
		dispatchEvent( new PayloadEvent(PayloadEvent.CALL, [action, value,
			_selectedBlog.id], null, false) );
	}
	
	/**
	 * @private
	 */
	private function reportDirty(event:PropertyChangeEvent=null):void
	{
		//Called when a blog record property is changed.
		dispatchEventType("dirtyChange");
	}
	
	/**
	 * @private
	 */
	private function reportEditing(value:Boolean = true):void
	{
		//Called when a post record property is changed.
		dispatchEvent( new PayloadEvent(PayloadEvent.EDITING, value) );
	}
	
	/**
	 * @private
	 */
	private function setSelectedPost(value:Post, report:Boolean = true):void
	{
		if (_modelSelectedPost != null)
		{
			_modelSelectedPost.removeEventListener(
				PropertyChangeEvent.PROPERTY_CHANGE, reportDirty);
		}
		_modelSelectedPost = value;
		
		dispatchEventType("selectedPostChange");
		
		//Let other managers know post is being shown.
		if (report)
			dispatchEvent( new PayloadEvent(PayloadEvent.SHOW_POST, 
				_modelSelectedPost) );
		
		//Create a reference blog to track editing changes, if any.
		if (_modelSelectedPost != null)
			_pendingPost = _modelSelectedPost.clone;
		
		//Refresh the dirty status after the pending comparison blog is created.
		reportDirty();
		
		if (_modelSelectedPost != null)
			_modelSelectedPost.addEventListener(
				PropertyChangeEvent.PROPERTY_CHANGE, reportDirty);
	}
}
	
}
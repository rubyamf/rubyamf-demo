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
import com.rubyamf.demo.vos.CallResult;

import flash.display.Sprite;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;

public class CommentsManager extends AManager
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function CommentsManager()
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
	private var _pendingComment:Comment;
	
	/**
	 * @private
	 */
	private var _selectedBlog:Blog;
	
	/**
	 * @private
	 */
	private var _selectedPost: Post;
	
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
		switch (event.kind)
		{
			case PayloadEventKind.CREATE:
			{
				//Do nothing, the create event bubbles to the PostsUI and is
				//handled there so that comments are saved in a Post record
				//to demonstrate accepts_nested_attributes in the ruby Post
				//model.
				
				break;
			}
			case PayloadEventKind.DELETE:
			{
				//Stop event from bubbling up to PostsUI
				event.stopImmediatePropagation();
				
				_pendingComment = event.data as Comment;
				
				showCenteredAlert("Are you sure you want to delete\nthe comment " +
					"'" + _pendingComment.name + "'?", 
					"Confirm Delete", Alert.OK | Alert.CANCEL, 
					event.target as Sprite, deleteCommentHandler,
					event.triggeringEvent as MouseEvent);
				break;
			}
			case PayloadEventKind.SAVE:
			{
				//Do nothing, let it percolate to PostsManager. In a real,
				//application this would handle creating the comment, but 
				//we do it through a post to demo nested attributes.
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
	}
	
	/**
	 * Handler for the PayloadEvent.SHOW_BLOG event.
	 */
	public function showPost(event:PayloadEvent):void
	{
		_selectedPost = event.data as Post;
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
			case RemoteService.DESTROY:
			{
				//We replace the item in the Blogs collection so that we don't 
				//have to reload it.
				replaceItem(_selectedPost.comments, _pendingComment, null);
				
				_pendingComment = null;
				break;
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function deleteCommentHandler(event:CloseEvent):void
	{
		if (event.detail == Alert.OK)
		{
			remoteCall(RemoteService.DESTROY, _pendingComment.id);
			_pendingComment;
		}	
	}
	
	/**
	 * @private
	 */
	private function remoteCall(action:String, value:Object):void
	{
		//Cancel bubbling so the BlogsLocalEventMap does not hear the event.
		dispatchEvent( new PayloadEvent(PayloadEvent.CALL, [action, value,
			_selectedPost.id, _selectedBlog.id], null, false) );
	}
}
	
}
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
import com.fosrias.library.utils.FileLoader;
import com.rubyamf.demo.events.PayloadEvent;
import com.rubyamf.demo.events.PayloadEventKind;
import com.rubyamf.demo.models.Blog;
import com.rubyamf.demo.models.interfaces.AListItem;
import com.rubyamf.demo.models.interfaces.IMemento;
import com.rubyamf.demo.vos.CallResult;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.PropertyChangeEvent;

/**
 * The BlogsManager class is the controller for the BlogsUI view.
 */
public class BlogsManager extends AManager
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function BlogsManager() 
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
	private var _fileLoader:FileLoader;
	
	/**
	 * @private
	 */
	private var _pendingAction:String;
	
	/**
	 * @private
	 */
	private var _pendingBlog:Blog;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  modelBlogs
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelBlogs property.
	 */
	private var _modelBlogs:ArrayCollection;
	
	[Bindable("blogsChange")]
	/**
	 * The blogs displayed.
	 */
	public function get modelBlogs():ArrayCollection
	{
		return _modelBlogs;
	}
	
	//----------------------------------
	//  modelIsDirty
	//----------------------------------
	
	[Bindable("dirtyChange")]
	/**
	 * Whether the blog has been edited or not.
	 */
	public function get modelIsDirty():Boolean
	{
		return _pendingBlog != null && 
			!_pendingBlog.isEqual(_modelSelectedBlog);
	}
	
	//----------------------------------
	//  modelSelectedBlog
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelSelectedBlog property.
	 */
	private var _modelSelectedBlog:Blog;
	
	[Bindable("selectedBlogChange")]
	/**
	 * The currently selected blog to display.
	 */
	public function get modelSelectedBlog():Blog
	{
		return _modelSelectedBlog;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for execute method from the associated view presentation model.
	 */
	public function execute(event:PayloadEvent):void
	{
		var blog:Blog;
			
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
				setAction("Create Blog");
				setSelectedBlog(new Blog(), false);
				reportEditing();
				break;
			}
			case PayloadEventKind.DELETE:
			{
				_pendingBlog = event.data as Blog;
				
				showCenteredAlert("Are you sure you want to delete\nthe Blog " +
					"'" + _pendingBlog.title +"'?", 
					"Confirm Delete", Alert.OK | Alert.CANCEL, 
					null, deleteBlogHandler, 
					event.triggeringEvent as MouseEvent);
				break;
			}
			case PayloadEventKind.EDIT:
			{
				if (_modelSelectedBlog == event.data)
				{
					setAction("Edit Blog");
					reportEditing();
		
				} else {
					
					_pendingAction = "Edit Blog";
					
					blog = event.data as Blog;
				
					//Load the blog from the remote service to pick up 
					//scoped attributes of the blog.
					remoteCall([RemoteService.SHOW, blog.id]);
				}
				break;
			}
			case PayloadEventKind.LOAD:
			{
				_fileLoader = FileLoader.getInstance();
				_fileLoader.addEventListener(Event.COMPLETE, onFileLoadComplete, 
					false, 0, true);
				
				_fileLoader.browse(FileLoader.IMAGES_FILTER);
				break;
			}
			case PayloadEventKind.SAVE:
			{
				var remoteAction:String;
				
				if (_modelSelectedBlog.isNew)
				{
					remoteAction = RemoteService.CREATE;
					
				} else {
					
					remoteAction = RemoteService.UPDATE;
				}
				remoteCall([remoteAction, _modelSelectedBlog]);
				
				//Clear the editing mode
				setAction(null);
				break;
			}
			case PayloadEventKind.SHOW:
			{
				blog = event.data as Blog;

				//Load the blog from the remote service to pick up 
				//scoped attributes of the blog.
				remoteCall([RemoteService.SHOW, blog.id]);
				break;
			}
		}
	}
	
	/**
	 * Handler that resets the view to show Blogs index.
	 */
	public function showBlog(event:PayloadEvent):void
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
				_modelBlogs.addItem(result.data);
				reportEditing(false);
				break;
			}
			case RemoteService.DESTROY:
			{
				if (result.data == true)
					_modelBlogs = replaceItem(_modelBlogs, 
						_modelSelectedBlog, null);
				break;
			}
			case RemoteService.INDEX:
			{
				_modelBlogs = result.data as ArrayCollection;
				break;
			}
			case RemoteService.SHOW:
			{
				setSelectedBlog(result.data as Blog);

				if (_pendingAction != null)
				{
					setAction(_pendingAction);
					_pendingAction = null;
					reportEditing();
				}
				
				//Show the blog and its posts.
				setViewIndex(1);
				break;
			}
			case RemoteService.UPDATE:
			{
				//We replace the item in the Blogs collection so that we don't 
				//have to reload it.
				_modelBlogs = replaceItem(_modelBlogs, 
					_modelSelectedBlog, result.data as AListItem);
				
				//We update the currently selected blog with the remote changes
				setSelectedBlog(result.data as Blog);
				reportEditing(false);
				break;
			}	
		}
		dispatchEventType("blogsChange");
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
			_modelSelectedBlog.restore(_pendingBlog);
		
		reportEditing(false);
	}
	
	/**
	 * @private
	 */
	private function deleteBlogHandler(event:CloseEvent):void
	{
		if (event.detail == Alert.OK)
			remoteCall([RemoteService.DESTROY, _pendingBlog.id]);
		
		//Reset the pending blog
		setSelectedBlog(_pendingBlog);
	}
	
	/**
	 * @private
	 */
	private function onFileLoadComplete(event:Event):void
	{
		_fileLoader.removeEventListener(Event.COMPLETE, onFileLoadComplete);
		
		if (_fileLoader.isImage)
		{
			_modelSelectedBlog.image = _fileLoader.fileContent;
			
			//Clone so binding events fire.
			setSelectedBlog(_modelSelectedBlog.clone, false, false);
		}
		
		//Clear so does not trigger if used elsewhere
		_fileLoader = null;
	}
	
	/**
	 * @private
	 */
	private function remoteCall(value:Object):void
	{
		dispatchEvent( new PayloadEvent(PayloadEvent.CALL, value) );
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
		//Called when a blog record property is changed.
		dispatchEvent( new PayloadEvent(PayloadEvent.EDITING, value) );
	}
	
	/**
	 * @private
	 */
	private function setSelectedBlog(value:Blog, 
									 report:Boolean = true,
									 reset:Boolean = true):void
	{
		if (_modelSelectedBlog != null)
			_modelSelectedBlog.removeEventListener(
				PropertyChangeEvent.PROPERTY_CHANGE, reportDirty);
		
		_modelSelectedBlog = value;
 		dispatchEventType("selectedBlogChange");
		
		//Let other managers know blog is being shown.
		if (report)
			dispatchEvent( new PayloadEvent(PayloadEvent.SHOW_BLOG, 
				_modelSelectedBlog) );
		
		//Create a reference blog to track editing changes, if any.
		if (_modelSelectedBlog != null && reset)
			_pendingBlog = _modelSelectedBlog.clone;
		
		//Refresh the dirty status after the pending comparison blog is created.
		reportDirty();

		if (_modelSelectedBlog != null)
			_modelSelectedBlog.addEventListener(
				PropertyChangeEvent.PROPERTY_CHANGE, reportDirty);
	}
}
	
}
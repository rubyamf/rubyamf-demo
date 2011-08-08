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
import com.fosrias.library.managers.interfaces.AManager;
import com.rubyamf.demo.events.PayloadEvent;
import com.rubyamf.demo.events.PayloadEventKind;
import com.rubyamf.demo.vos.CallResult;

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/**
 * The MainManager is the controller for the <code>MainUI</code> view.
 */
public class MainManager extends AManager
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The constant is the label for the back button for Blogs.
	 */
	public static const BLOGS:String = "Blogs";
	
	/**
	 * The constant is the label for the back button for Posts.
	 */
	public static const POSTS:String = "Posts";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function MainManager()
	{
		super(this);
		
		//Handles global untrapped faults.
		_reportFault = true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _showNoticeIndex:uint;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  modelBreadcrumbs
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelBreadcrumbs property.
	 */
	private var _modelBreadcrumbs:Array;
	
	[Bindable("breadcrumbsChange")]
	[Bindable("editLockChange")]
	/**
	 * The label of the back button.
	 */
	public function get modelBreadcrumbs():Array
	{
		return _modeEditLock ? [] : _modelBreadcrumbs;
	}
	
	//----------------------------------
	//  modelHasEditLock
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelHasEditLock property.
	 */
	private var _modeEditLock:Boolean = false;
	
	[Bindable("editLockChange")]
	/**
	 * Whether the application has a global edit lock or not.
	 */
	public function get modelHasEditLock():Boolean
	{
		return _modeEditLock;
	}
	
	//----------------------------------
	//  modelNotice
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelNotice property.
	 */
	private var _modelNotice:String;
	
	[Bindable("noticeChange")]
	/**
	 * The notice returned by the server.
	 */
	public function get modelNotice():String
	{
		return _modelNotice;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for a MainUI PayloadEvent.EDITING event.
	 */
	public function editing(event:PayloadEvent):void
	{
		_modeEditLock = event.data;
		dispatchEventType("editLockChange");
	}
	
	/**
	 * Handler for a MainUI PayloadEvent.EXECUTE event.
	 */
	public function execute(event:PayloadEvent):void
	{
		var type:String;
		
		if (event.data == BLOGS)
		{
			type = PayloadEvent.SHOW_BLOG;
			reportBreadcrumbs([]);
			
		} else {
			
			type = PayloadEvent.SHOW_POST;
			reportBreadcrumbs([BLOGS]);
		}
		
		dispatchEvent( new PayloadEvent(type, null, PayloadEventKind.CANCEL) );
	}
	
	/**
	 * Handler for a MainUI PayloadEvent.SHOW_BLOG event.
	 */
	public function showBlog(event:PayloadEvent):void
	{
		//Ignore value from execute method
		if (event.kind == null)
			reportBreadcrumbs([BLOGS]);
	}
	
	/**
	 * Handler for a MainUI PayloadEvent.SHOW_BLOG event.
	 */
	public function showPost(event:PayloadEvent):void
	{
		//Ignore value from execute method
		if (event.kind == null)
			reportBreadcrumbs([POSTS, BLOGS]);
	}
	
	/**
	 * Shows a flash notice returned from the server if one exists.
	 */
	public function showNotice(value:CallResult):void
	{
		if (value != null && value.hasMessage)
		{
			clearTimeout(_showNoticeIndex);
			_modelNotice = value.message;
			dispatchEventType("noticeChange");
			
			_modelVisible = true;
			dispatchEventType("visibleChange");
			
			_showNoticeIndex = setTimeout(hideNotice, 1500);
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
	private function hideNotice():void
	{
		_modelVisible = false;
		dispatchEventType("visibleChange");
	}
	
	/**
	 * @private
	 */
	private function reportBreadcrumbs(value:Array):void
	{
		_modelBreadcrumbs = value;
		dispatchEventType("breadcrumbsChange");
	}
}
	
}
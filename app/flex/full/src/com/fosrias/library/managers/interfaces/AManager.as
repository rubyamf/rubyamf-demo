////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2011   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.managers.interfaces
{
import com.fosrias.library.business.RemoteService;
import com.fosrias.library.events.RemoteFaultEvent;
import com.fosrias.library.events.RemoteResultEvent;
import com.fosrias.library.interfaces.AClass;
import com.rubyamf.demo.events.PayloadEvent;
import com.rubyamf.demo.models.interfaces.AListItem;
import com.rubyamf.demo.views.MainUI;
import com.rubyamf.demo.vos.CallResult;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.System;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.core.FlexGlobals;
import mx.core.IFlexModuleFactory;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.managers.SystemManager;
import mx.rpc.CallResponder;
import mx.rpc.remoting.RemoteObject;

/**
 * The AManager class is the base class for all manager subclasses.
 */		
public class AManager extends AClass
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AManager(self:AManager)
	{
		super(self);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
	/**
	 * @private
	 */
	private var _remoteCallIntervalId:int;
	
	/**
	 * @private
	 */
	protected var _reportFault:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  modelAction
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelAction property.
	 */
	private var _modelAction:String;
	
	[Bindable("actionChange")]
	/**
	 * The action occuring to the underlying record.
	 */
	public function get modelAction():String
	{
		return _modelAction;
	}
	
	//----------------------------------
	//  modelViewIndex
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelViewIndex property.
	 */
	private var _modelViewIndex:int = 0;
	
	[Bindable("viewIndexChange")]
	/**
	 * The view index of the BlogsUI.
	 */
	public function get modelViewIndex():int
	{
		return _modelViewIndex;
	}
	
	//----------------------------------
	//  modelVisible
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the modelVisible property.
	 */
	protected var _modelVisible:Boolean = false;
	
	[Bindable("visibleChange")]
	/**
	 * Whether the view is visible or not.
	 */
	public function get modelVisible():Boolean
	{
		return _modelVisible;
	}
	
	//----------------------------------
	//  service
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the service property.
	 */
	private var _service:RemoteObject;

	/**
	 * The remote service associated with the manager.
	 */
	public function get service():RemoteObject
	{
		return _service;
	}

	/**
	 * @private
	 */
	public function set service(value:RemoteObject):void
	{
		_service = value;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Protected properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  hasPendingRemoteCall
    //----------------------------------
    
    /**
     * A that can be used to monitor remote calls.
     */
    protected var hasPendingRemoteCall:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handler for remote faults.
	 */
	public function callFault(event:RemoteFaultEvent):*
	{
		var faultMessage:String = event.faultString + "\n" + event.faultDetail;
		
		traceDebug(faultMessage);
		
		//Reports fault message in a popup.
		if (_reportFault)
			Alert.show(faultMessage, "Fault Message");
	}
	
	/**
	 * Handler for remote results.
	 */
	public function callResult(event:RemoteResultEvent):*
	{
		var result:CallResult = event.result as CallResult;
		
		//Broadcast flash notices
		FlexGlobals.topLevelApplication.dispatchEvent( new PayloadEvent(
			PayloadEvent.FLASH, result) );
		
		//Check if the notice came from a live demo. If so, exit the method
		//since return results were cancelled remotely.
		var message:String = result.message;
		
		if (result.data == false && message.lastIndexOf("Demo") != -1)
			return false;
		
		return true;
	}

    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Utility method to clear timeout associated with pending call.
     */
    protected function clearCallTimeout():void
    {
        hasPendingRemoteCall = false;
        clearTimeout(_remoteCallIntervalId);
    }
	
	/**
	 * Opens and Alert prompt centered in the screen, vs. the application.
	 */
	protected function showCenteredAlert(text:String = "", 
										 title:String = "",
										 flags:uint = 0x4 /* Alert.OK */, 
										 parent:Sprite = null, 
										 closeHandler:Function = null, 
										 triggeringEvent:MouseEvent = null,
										 iconClass:Class = null, 
										 defaultButtonFlag:uint = 0x4 /* Alert.OK */,
										 moduleFactory:IFlexModuleFactory = null):void
	{
 
		var alert:Alert = Alert.show(text, title, flags, parent, closeHandler,
			iconClass, defaultButtonFlag, moduleFactory);
		
		//Position the alert
		PopUpManager.centerPopUp(alert);
		var x:Number = alert.x;
		var y:Number = alert.y;
		
		//Determine the height location
		if (triggeringEvent != null)
		{
		
			var location: Point = UIComponent(triggeringEvent.target).
				localToGlobal( new Point(triggeringEvent.localX, 
					triggeringEvent.localY) );
			y = location.y;
		}
		alert.move (x, y);	
	}
	
	/**
	 * Utility method to replace or remove and item from an array.
	 */
	protected function replaceItem(collection:ArrayCollection, 
								   item:AListItem, 
								   replacement:AListItem):ArrayCollection
	{
		var length:int = collection.length;
		for (var i:int = 0; i < length; i++)
		{
			if (collection[i].id == item.id)
			{
				collection.removeItemAt(i);
				break;
			}
		}
		if (replacement != null)
			collection.addItemAt(replacement, i);
		
		return collection;
	}
								   
	
	/**
	 * Sets the editing action.
	 */
	protected function setAction(value:String):void
	{
		_modelAction = value;
		dispatchEventType("actionChange");
	}
	
	/**
     * The current session user.
     */
    protected function setCallTimeout(closure:Function, 
                                      delay:Number, 
                                      ... arguments):void
    {
        hasPendingRemoteCall = true;
       _remoteCallIntervalId = setTimeout( closure, delay, arguments );
    }
	
	/**
	 * Sets the view index.
	 */
	protected function setViewIndex(value:int):void
	{
		_modelViewIndex = value;
		dispatchEventType("viewIndexChange");
	}
	
	/**
	 * Sets the visiblility of the view.
	 */
	protected function setVisible(value:Boolean):void
	{
		_modelVisible = value;
		dispatchEventType("visibleChange");
	}
}

}
package com.rubyamf.demo.events
{
import flash.events.Event;

/**
 * The PayloadEvent a base event class for events carrying customizable
 * payloads and kinds.
 * 
 * @see http://afusion.mate.com
 */
public class PayloadEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  Action types
	//----------------------------------
	
	/**
	 * The PayloadEvent.EDITING constant is a type of PayloadEvent that
	 * represents an event associated with displaying a editing a blog or post.
	 */
	public static const EDITING:String = "editing";
	
	/**
	 * The PayloadEvent.SHOW_BLOG constant is a type of PayloadEvent that
	 * represents an event associated with displaying a Blog.
	 */
	public static const SHOW_BLOG:String = "showBlog";
	
	/**
	 * The PayloadEvent.SHOW_POST constant is a type of PayloadEvent that
	 * represents an event associated with displaying a POST.
	 */
	public static const SHOW_POST:String = "showPost";
	
	//----------------------------------
	//  Message types
	//----------------------------------
	
	/**
	 * The PayloadEvent.FLASH constant is a type of PayloadEvent that
	 * represents an event associated with displaying a flash notice.
	 */
	public static const FLASH:String = "flash";
	
	//----------------------------------
	//  Remote service types
	//----------------------------------
	
	/**
	 * The PayloadEvent.CALL constant is a type of PayloadEvent that
	 * represents an event associated with a RemoteObject service call.
	 */
	public static const CALL:String = "call";
	
	//----------------------------------
	//  View model types
	//----------------------------------
	
	/**
	 * The PayloadEvent.DIRTY constant is a type of PayloadEvent that
	 * represents an event associated with a Presentation Model dispatch
	 * to interact with a manager method, typically <code>setDirty</code>.
	 */
	public static const DIRTY:String = "dirty";
	
	/**
	 * The PayloadEvent.INDEX constant is a type of PayloadEvent that
	 * represents and event associated with a RemoteObject service call to
	 * its index method.
	 */
	public static const EXECUTE:String = "execute";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function PayloadEvent(type:String, 
								 data:Object = null, 
								 kind:String = null, 
								 bubbles:Boolean = true,
								 triggeringEvent:Event = null)
	{
		super(type, bubbles, false);
		_data = data;
		_kind = kind;
		_triggeringEvent = triggeringEvent;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  data
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the data property.
	 */
	private var _data:Object;
	
	/**
	 * The data payload of the event.
	 */
	public function get data():Object
	{
		return _data;
	}
	
	//----------------------------------
	//  kind
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the kind property.
	 */
	private var _kind:String;
	
	/**
	 * The kind of event, if any.
	 */
	public function get kind():String
	{
		return _kind;
	}
	
	//----------------------------------
	//  triggeringEvent
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the triggeringEvent property.
	 */
	private var _triggeringEvent:Event;
	
	/**
	 * The event that triggering event, if any.
	 */
	public function get triggeringEvent():Event
	{
		return _triggeringEvent;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new PayloadEvent(type, _data, _kind, bubbles, _triggeringEvent);
	}
}
	
}
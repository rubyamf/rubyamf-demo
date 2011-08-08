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

[Bindable]
/**
 * The MainViewModel is the presentation view model for the 
 * <code>MainUI</code> view.
 */
public class MainViewModel extends AViewModel
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function MainViewModel()
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Injected properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  notice
	//----------------------------------
	
	/**
	 * The notice message.
	 */
	public var notice:String;
	
	//----------------------------------
	//  breadcrumbs
	//----------------------------------
	
	/**
	 * The breadcrumbs to show.
	 */
	public var breadcrumbs:Array;
}
	
}
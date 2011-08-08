////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.library.models.interfaces
{
/**
 * The IIsEqual interface is implemented by classes that compare properties
 * for equality other instances of their same class. 
 */
public interface IIsEqual
{
    /**
     * Whether the object object is equal to the class calling the 
     * <code>isEqual</code> method.
     * 
     * @param value The object to be compared.
     */
    function isEqual( value:Object ):Boolean;
}

}
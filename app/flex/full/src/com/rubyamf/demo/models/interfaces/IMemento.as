package com.rubyamf.demo.models.interfaces
{
public interface IMemento
{
	/**
	 * Restores the state of the object from another memento (sort of since
	 * not actually a static item).
	 */
	function restore(memento:IMemento):void;
}

}
package com.fosrias.library.views.components
{
import spark.components.RichEditableText;
import spark.components.TextArea;

/**
 * The AutoScaleRichEditableText class is used as the textDisplay object in 
 * skins that auto-scale in the vertical direction. More complicated in the
 * horizontal direction so I leave that to someone else. 
 * 
 * @see com.fosrias.components.AutoScalingTextAreaSkin.mxml
 */
public class AutosizingRichEditableText extends RichEditableText
{
	public function AutosizingRichEditableText()
	{
		super();
	}
	
	/**
	 *  We allow the heightConstraint to be NaN if the corresponding autoScale 
	 * value is true.
	 */
	override public function setLayoutBoundsSize(width:Number, 
												 height:Number,
												 postLayoutTransform:Boolean 
												 	 = true):void
	{
		//This makes sure that if the text is programmatically reset,
		//the height of the rich editable text tracks with the text area size.
		//Without this, programmatically resetting the text would result in a
		//0 height skin since RichEditableText has heightInLines = NaN.
		if (parentDocument.owner is TextArea)
		{
			height = parentDocument.owner;
		}
		
		super.setLayoutBoundsSize(width, height, postLayoutTransform);
		
		//This is all it takes (plus hours of tracing source code)
		heightInLines  = NaN;
	}
}

}
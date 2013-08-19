package net.flashpunk.utils.textures 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * A subtexture on a TextureAtlas.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Subtexture 
	{
		/** The region of the TextureAtlas containing the Subtexture. */
		public var region:Rectangle;
		/** The offset of the Subtexture after unpacking. */
		public var offset:Point;
		/** The final size of the Subtexture after unpacking. */
		public var dimensions:Point;
		
		public function Subtexture(x:uint, y:uint, width:uint, height:uint, offsetX:uint = 0, offsetY:uint = 0, frameWidth:uint = 0, frameHeight:uint = 0) 
		{
			if (width == 0 || height == 0)
			{
				throw new Error("Invalid Subtexture dimensions.");
			}
			
			region = new Rectangle(x, y, width, height);
			offset = new Point(offsetX, offsetY);
			
			// If both frameWidth and frameHeight are untouched, use the specified width and height.
			// Otherwise, use the values of frameWidth and frameHeight.
			if (frameWidth == 0 && frameHeight == 0)
			{
				dimensions = new Point(width, height);
			}
			else
			{
				dimensions = new Point(frameWidth, frameHeight);
			}
		}
		
		
		
	}

}
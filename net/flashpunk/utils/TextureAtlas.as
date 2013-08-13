package net.flashpunk.utils 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/** Provides atlased texture support. */
	public class TextureAtlas 
	{
		public function TextureAtlas(texture:*, atlas:*) 
		{
			// Get the BitmapData.
			if (texture is Class)
			{
				_texture = FP.getBitmap(texture);
			}
			else if (texture is BitmapData)
			{
				_texture = texture;
			}
			
			if (!_texture)
			{
				throw new Error("Invalid texture.");
			}
			
			// Get the XML.
			if (atlas is Class)
			{
				_atlas = FP.getXML(atlas);
			}
			else if (atlas is XML)
			{
				_atlas = atlas;
			}
			
			if (!_atlas)
			{
				throw new Error("Invalid atlas.");
			}
		}
		
		public function GetImage(subtextureName:String):Image
		{
			var node:XMLList = _atlas.SubTexture.(@name == subtextureName);
			var image:Image;
			
			if (node != XMLList(_atlas))
			{
				var clipRectangle:Rectangle = new Rectangle(node.@x, node.@y, node.@width, node.@height);
				image = new Image(_texture, clipRectangle);
				if (node.hasOwnProperty('@frameX')) image.x = node.@frameX;
				if (node.hasOwnProperty('@frameY')) image.y = node.@frameY;
			}
			
			return image;
		}
		
		private var _atlas:XML;
		private var _texture:BitmapData;
	}

}
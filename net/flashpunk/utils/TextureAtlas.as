package net.flashpunk.utils 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;

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

		/**
		 * Get an Image from a defined SubTexture in the TextureAtlas
		 * @param   subTexture The name of the SubTexture in the TextureAtlas.
		 * @return  The specified Image.
		 */
		public function getImage(subTexture:String):Image
		{
			var node:XMLList = _atlas.SubTexture.(@name == subTexture);
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

		/**
		 * Get a Tilemap from a defined Tileset in the TextureAtlas.
		 * @param   tileset The name of the Tileset defined in the TextureAtlas.
		 * @param   width The width of the Tilemap.
		 * @param   height The height of the Tilemap.
		 * @return  The specified Tilemap.
		 */
		public function getTilemap(tileset:String, width:uint, height:uint):Tilemap
		{
			var node:XMLList = _atlas.Tileset.(@name == tileset);
			var tilesetSize:int = node.Tile.length();

			var tileWidth:uint = uint(node.@tileWidth);
			var tileHeight:uint = uint(node.@tileHeight);

			if (tileWidth == 0 || tileHeight == 0)
			{
				throw new Error("Invalid tile dimensions.");
			}

			// Add an extra space at the start for a blank tile.
			var compiledTileset:BitmapData = new BitmapData(tileWidth * tilesetSize + 1, tileHeight, true, 0);
			var targetPoint:Point = new Point();
			var sourceRect:Rectangle = new Rectangle();
			var tileSource:String;

			for (var i:uint = 0; i < tilesetSize; i++)
			{
				tileSource = node.Tile[i].@source;
				targetPoint.x = (i + 1) * tileWidth;
				sourceRect.x = _atlas.SubTexture.(@name == tileSource).@x;
				sourceRect.y = _atlas.SubTexture.(@name == tileSource).@y;
				// TODO: Support trimmed tiles.
				sourceRect.width = tileWidth;
				sourceRect.height = tileHeight;
				trace("Adding tile from source rectangle:", sourceRect);
				compiledTileset.copyPixels(_texture, sourceRect, targetPoint);
			}

			return new Tilemap(compiledTileset, width, height, tileWidth, tileHeight);
		}

		/**
		 * Get a Backdrop from a defined SubTexture in the TextureAtlas.
		 * @param   subTexture The name of the SubTexture in the TextureAtlas.
		 * @param   repeatX Should the Backdrop repeat horizontally?
		 * @param   repeatY Should the Backdrop repeat vertically?
		 * @return  The specified Backdrop.
		 */
		public function getBackdrop(subTexture:String, repeatX:Boolean = true, repeatY:Boolean = true):Backdrop
		{
			var width:uint = uint(_atlas.SubTexture.(@name == subTexture).@width);
			var height:uint = uint(_atlas.SubTexture.(@name == subTexture).@height);
			var x:uint = uint(_atlas.SubTexture.(@name == subTexture).@x);
			var y:uint = uint(_atlas.SubTexture.(@name == subTexture).@y);

			// TODO: Perform error-checking on the dimensions.
			// TODO: Support trimmed tiles.
			var backdropData:BitmapData = new BitmapData(width, height, true, 0);
			backdropData.copyPixels(_texture, new Rectangle(x, y, width, height), new Point());

			return new Backdrop(backdropData, repeatX, repeatY);
		}
		
		private var _atlas:XML;
		private var _texture:BitmapData;
	}

}
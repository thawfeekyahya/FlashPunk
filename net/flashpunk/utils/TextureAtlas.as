package net.flashpunk.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.utils.textures.Subtexture;
	import net.flashpunk.utils.textures.Tileset;

	/** Provides atlased texture support. */
	public class TextureAtlas 
	{
		/** Construct a new TextureAtlas
		 * @param	texture The source texture for the TextureAtlas.
		 */
		public function TextureAtlas(texture:*) 
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
			
			_atlas = new Object();
		}
		
		/**
		 * Define a Subtexture on the TextureAtals.
		 * @param	name The reference name of the Subtexture.
		 * @param	x The x-location of the top-left corner of the Subtexture.
		 * @param	y The y-location of the top-left corner of the Subtexture.
		 * @param	width The width of the Subtexture.
		 * @param	height The height of the Subtexture.
		 * @param	offsetX The horizontal padding required (if any).
		 * @param	offsetY The vertical padding required (if any).
		 * @param	frameWidth The width of the unpacked Subtexture (if different from width).
		 * @param	frameHeight The height of the unpacked Subtexture (if different from height).
		 */
		public function defineSubtexture(name:String, x:uint, y:uint, width:uint, height:uint, offsetX:uint = 0, offsetY:uint = 0, frameWidth:uint = 0, frameHeight:uint = 0):void
		{
			_atlas[name] = new Subtexture(x, y, width, height, offsetX, offsetY, frameWidth, frameHeight);
		}
		
		public function getSubtexture(name:String):Subtexture
		{
			if (!_atlas.hasOwnProperty(name))
			{
				throw new Error("Subtexture \"" + name + "\" does not exist in the TextureAtlas.");
			}
			
			return Subtexture(_atlas[name]);
		}

		/**
		 * Get an Image from a defined SubTexture in the TextureAtlas
		 * @param   name The name of the Subtexture in the TextureAtlas.
		 * @return  The specified Image.
		 */
		public function getImage(name:String):Image
		{
			if (!_atlas.hasOwnProperty(name))
			{
				throw new Error("Invalid Subtexture name.");
			}
			
			var image:Image = new Image(_texture, Subtexture(_atlas[name]).region);
			image.x = Subtexture(_atlas[name]).offset.x;
			image.y = Subtexture(_atlas[name]).offset.y;
			
			return image;
		}

		/**
		 * Get a Tilemap from a defined Tileset in the TextureAtlas.
		 * @param   tileset The Tileset to get a Tilemap from.
		 * @param   width The width of the Tilemap.
		 * @param   height The height of the Tilemap.
		 * @return  The specified Tilemap.
		 */
		public function getTilemap(tileset:Tileset, width:uint, height:uint):Tilemap
		{
			if (tileset.isContiguous)
			{
				// The Tileset is contained in a single Subtexture. This was easy.
				return new Tilemap(getBitmapData(tileset.tiles[0]), width, height, tileset.tileWidth, tileset.tileHeight);
			}
			
			// The tileset is comprised of a bunch of individual tiles. Let's make a big tileset of them.
			var tilesetLength:uint = tileset.length;
			var tilesetTexture:BitmapData = new BitmapData(tilesetLength * tileset.tileWidth, tileset.tileHeight, true, 0);
			var st:Subtexture;
			
			for (var i:uint = 0; i < tilesetLength; i++)
			{
				copySubtexture(tilesetTexture, tileset.tiles[i], new Point(i * tileset.tileWidth, 0));
			}

			return new Tilemap(tilesetTexture, width, height, tileset.tileWidth, tileset.tileHeight);
		}

		/**
		 * Get a Backdrop from a defined SubTexture in the TextureAtlas.
		 * @param   name The name of the SubTexture in the TextureAtlas.
		 * @param   repeatX Should the Backdrop repeat horizontally?
		 * @param   repeatY Should the Backdrop repeat vertically?
		 * @return  The specified Backdrop.
		 */
		public function getBackdrop(name:String, repeatX:Boolean = true, repeatY:Boolean = true):Backdrop
		{
			if (!_atlas.hasOwnProperty(name))
			{
				throw new Error("Invalid Subtexture name.");
			}

			return new Backdrop(getBitmapData(_atlas[name]), repeatX, repeatY);
		}
		
		/**
		 * Create a BitmapData from a Subtexture definition.
		 * @param	subtexture The Subtexture defining the BitmapData.
		 * @return A BitmapData defined by subtexture.
		 */
		protected function getBitmapData(subtexture:Subtexture):BitmapData
		{
			var texture:BitmapData = new BitmapData(subtexture.dimensions.x, subtexture.dimensions.y, true, 0);
			texture.copyPixels(_texture, subtexture.region, subtexture.offset);
			return texture;
		}
		
		/**
		 * Copy the pixels specified by a Subtexture to the target BitmapData.
		 * @param	target
		 * @param	subtexture
		 * @param	destPoint
		 * @param	alphaBitmapData
		 * @param	alphaPoint
		 * @param	mergeAlpha
		 */
		protected function copySubtexture(target:BitmapData, subtexture:Subtexture, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Boolean = false):void
		{
			target.copyPixels(_texture, subtexture.region, destPoint.add(subtexture.offset), alphaBitmapData, alphaPoint, mergeAlpha);
		}
		
		private var _texture:BitmapData;
		private var _atlas:Object;
	}

}

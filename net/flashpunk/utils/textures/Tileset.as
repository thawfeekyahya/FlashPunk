package net.flashpunk.utils.textures 
{
	/**
	 * Defines a tileset composed of Subtextures.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Tileset 
	{
		/** The width of each tile. */
		public function get tileWidth():uint { return _tileWidth; }
		/** The height of each tile. */
		public function get tileHeight():uint { return _tileHeight; }
		/** (Are all the tiles in a single Subtexture?) */
		public function get isContiguous():Boolean { return _isContiguous; }
		/** The number of tiles in the tileset. */
		public function get length():uint { return tiles.length; }
		/** The list of Subregions containing tiles. */
		public var tiles:Vector.<Subtexture>;
		
		
		public function Tileset(tileWidth:uint, tileHeight:uint, isContiguous:Boolean) 
		{
			if (tileWidth == 0 || tileHeight == 0)
			{
				throw new Error("Invalid tile dimensions.");
			}
			
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
			_isContiguous = isContiguous;
			tiles = new Vector.<Subtexture>();
		}
		
		/**
		 * Add a tile defined by a Subtexture to the TileSet
		 * @param	subtexture The tile to add.
		 */
		public function addTile(subtexture:Subtexture):void
		{
			tiles.push(subtexture);
		}
		
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		private var _isContiguous:Boolean;
	}
}
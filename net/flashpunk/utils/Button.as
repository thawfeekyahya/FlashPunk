package net.flashpunk.utils
{
	import flash.events.MouseEvent;
	import net.flashpunk.graphics.Text;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.utils.Input;
	
	public class Button extends Entity
	{
		public var callback:Function = null;
		
		private var initialized:Boolean = false;
		
		private var _text:Text;
		private var _normal:Graphic = new Graphic;
		private var _hover:Graphic = new Graphic;
		private var _down:Graphic = new Graphic;
		
		private var _normalChanged:Boolean = false;
		private var _hoverChanged:Boolean = false;
		private var _downChanged:Boolean = false;
		
		public var shouldCall:Boolean = true;
		
		private var _over:uint;
		private var _color:uint;
		
		public function Button(text:String,callback:Function=null,x:Number=0, y:Number=0, width:int=0, height:int=0,color:uint=0xffffff,over:uint=0xd8d8d8)
		{
			
			_text = new Text(text, x, y);
			_text.relative = false;
			_text.color = color;
			_text.centerOrigin();
			_over = over;
			_color = color;
			setHitbox(_text.width, _text.height);
			this.callback = callback;
			super(x, y, _text);
			super.centerOrigin();
			
		}
		
		override public function update():void
		{
			if(!initialized)
			{
				if(FP.stage != null)
				{
					FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					initialized = true;
				}
			}
			
			super.update();
			
			if(visible && collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				if(Input.mousePressed)
				{
					if(graphic != _down || _downChanged)
					{
						graphic = new Graphiclist(_text,_down);
						_downChanged = false;
					}
				}
				else if(graphic != _hover || _hoverChanged)
				{
					 graphic = new Graphiclist(_text,_hover);
					_hoverChanged = false;
					_text.color = _over;
				}
			}
			else if(graphic != _normal || _normalChanged)
			{
				_text.color = _color;
				graphic = new Graphiclist(_text,normal);
				_normalChanged = false;
			}
		}
		
		private function onMouseUp(e:MouseEvent=null):void
		{
			if(!shouldCall || (callback == null)) return;
			if(visible && collidePoint(x, y, Input.mouseX, Input.mouseY)) callback();
		}
		
		override public function removed():void
		{
			super.removed();
			
			if(FP.stage != null)
				FP.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function set normal(normal:Graphic):void
		{
			_normal = normal;
			_normalChanged = true;
		}
		
		public function set hover(hover:Graphic):void
		{
			_hover = hover;
			_hoverChanged = true;
		}
		
		public function set down(down:Graphic):void
		{
			_down = down;
			_downChanged = true;
		}
		
		public function get normal():Graphic{ return _normal; }
		public function get hover():Graphic{ return _hover; }
		public function get down():Graphic{ return _down; }

        public function setX(val:Number):void {
            this.x = val;
            _text.x = val;
        }

        public function setY(val:Number):void{
            this.y = val;
            _text.y = val;
        }

	}
}
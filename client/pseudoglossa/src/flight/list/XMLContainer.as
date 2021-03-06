////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2009 Tyler Wright, Robert Taylor, Jacob Wright
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package flight.list
{
	import flash.events.Event;
	
	import flight.events.PropertyEvent;
	import flight.vo.ValueObject;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class XMLContainer extends ValueObject implements IList
	{
		private var _source:XMLList;
		
		public function XMLContainer(source:XMLList = null)
		{
			if(source != null) {
				this.source = source;
			}
		}
		
		[Bindable(event="propertyChange", flight="true")]
		public function get source():XMLList
		{
			if(_source == null) {
				_source = new XMLList();
			}
			return _source;
		}
		public function set source(value:XMLList):void
		{
			if(_source == value) {
				return;
			}
			
			var oldValue:XMLList = _source;
			_source = value;
			dispatchEvent(new Event(Event.CHANGE));
			PropertyEvent.dispatchChange(this, "source", oldValue, _source);
		}
		
		public function get numItems():int
		{
			return source.length();
		}
		
		public function addItem(item:Object):Object
		{
			source += item;
			dispatchEvent(new Event(Event.CHANGE));
			return item;
		}
		
		public function addItemAt(item:Object, index:int):Object
		{
			if(index == 0) {
				source[0] = source.length() == 0 ? item : item + source[0];
			} else {
				source[index-1] += item;
			}
			dispatchEvent(new Event(Event.CHANGE));
			return item;
		}
		
		public function getItemAt(index:int):Object
		{
			return source[index];
		}
		
		public function getItemIndex(item:Object):int
		{
			for(var i:String in source) {
				if(source[i] == item) {
					return Number(i);
				}
			}
			return -1;
		}
		
		public function removeItem(item:Object):Object
		{
			return removeItemAt(getItemIndex(item));
		}
		
		public function removeItemAt(index:int):Object
		{
			var item:XML = source[index];
			delete source[index];
			dispatchEvent(new Event(Event.CHANGE));
			return item;
		}
		
		public function removeItems():void
		{
			for(var i:String in source) {
				delete source[i];
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setItemIndex(item:Object, index:int):Object
		{
			delete source[getItemIndex(item)];
			return addItemAt(item, index);
		}
		
		public function swapItems(item1:Object, item2:Object):void
		{
			var index1:int = getItemIndex(item1);
			var index2:int = getItemIndex(item2);
			swapItemsAt(index1, index2);
		}
		
		public function swapItemsAt(index1:int, index2:int):void
		{
			var item1:XML = source[index1];
			var item2:XML = source[index2];
			
			if(index1 < index2) {
				delete source[index2];
				delete source[index1];
				source[index2-1] += item1;
				addItemAt(item2, index1);
			} else {
				delete source[index1];
				delete source[index2];
				source[index1-1] += item2;
				addItemAt(item1, index2);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function equals(value:Object):Boolean
		{
			var compare:XMLList = value is XMLContainer ? XMLContainer(value).source : value as XMLList;
			return compare.toXMLString() == source.toXMLString();
		}
		
		override public function clone():Object
		{
			return new XMLContainer(source.copy());
		}
		
	}
}

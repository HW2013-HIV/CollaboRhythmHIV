/**
 * Copyright 2011 John Moore, Scott Gilroy
 *
 * This file is part of CollaboRhythm.
 *
 * CollaboRhythm is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later
 * version.
 *
 * CollaboRhythm is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with CollaboRhythm.  If not, see
 * <http://www.gnu.org/licenses/>.
 */
package collaboRhythm.shared.model
{
	public class CodedValue
	{
		private var _type:String;
		private var _value:String;
		private var _abbrev:String;
		private var _text:String;
		
		public function CodedValue(type:String="", value:String="", abbrev:String="", text:String="")
		{
			_type = type;
			_value = value;
			_abbrev = abbrev;
			_text = text;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function get value():String
		{
			return _value;
		}
		
		public function get abbrev():String
		{
			return _abbrev;
		}

		public function get text():String
		{
			return _text;
		}
	}
}
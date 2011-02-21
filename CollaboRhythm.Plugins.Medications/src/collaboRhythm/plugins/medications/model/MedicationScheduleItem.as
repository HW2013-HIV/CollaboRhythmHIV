/**
 * Copyright 2011 John Moore, Scott Gilroy
 *
 * This file is part of CollaboRhythm.
 *
 * CollaboRhythm is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * CollaboRhythm is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with CollaboRhythm.  If not, see <http://www.gnu.org/licenses/>.
 */
package collaboRhythm.plugins.medications.model
{
	import collaboRhythm.plugins.medications.view.MedicationScheduleItemFullView;
	import collaboRhythm.plugins.medications.view.MedicationScheduleItemWidgetView;
	import collaboRhythm.plugins.schedule.shared.model.ScheduleGroup;
	import collaboRhythm.plugins.schedule.shared.model.ScheduleItemBase;
	import collaboRhythm.plugins.schedule.shared.view.ScheduleItemFullViewBase;
	import collaboRhythm.plugins.schedule.shared.view.ScheduleItemWidgetViewBase;
	import collaboRhythm.shared.model.HealthRecordHelperMethods;
	import collaboRhythm.shared.model.ValueAndUnit;
	
	public class MedicationScheduleItem extends ScheduleItemBase
	{
		private var _dose:ValueAndUnit;
		private var _scheduledActionID:String;
		private var _scheduledAction:Medication;
		private var _scheduleGroupID:String;

		public function MedicationScheduleItem(scheduleItemReportXML:XML):void
		{
			super(scheduleItemReportXML, "MedicationScheduleItem");
			
			_dose = new ValueAndUnit(_scheduleItemXML.dose.value, HealthRecordHelperMethods.codedValueFromXml(_scheduleItemXML.dose.unit[0]));
			_scheduledActionID = scheduleItemReportXML.Meta.Document.relatesTo.relation.relatedDocument.@id;
			_scheduleGroupID =  scheduleItemReportXML.Meta.Document.isRelatedFrom.relation.relatedDocument.@id;
		}
		
		public function get dose():ValueAndUnit
		{
			return _dose;
		}
		
		public function get scheduledActionID():String
		{
			return _scheduledActionID;
		}
		
		public function get scheduledAction():Medication
		{
			return _scheduledAction;
		}
		
		public function set scheduledAction(value:Medication):void
		{
			_scheduledAction = value;
		}
		
		public function get scheduleGroupID():String
		{
			return _scheduleGroupID;
		}
		
		public override function createScheduleItemWidgetView():ScheduleItemWidgetViewBase
		{
			// to be implemented by subclasses
			var medicationScheduleItemWidgetView:MedicationScheduleItemWidgetView = new MedicationScheduleItemWidgetView();
			medicationScheduleItemWidgetView.medication = _scheduledAction;
			return medicationScheduleItemWidgetView;
		}
		
		public override function createScheduleItemFullView():ScheduleItemFullViewBase
		{
			// to be implemented by subclasses
			var medicationScheduleItemFullView:MedicationScheduleItemFullView = new MedicationScheduleItemFullView();
			medicationScheduleItemFullView.medication = _scheduledAction;
			return medicationScheduleItemFullView;
		}
	}
}
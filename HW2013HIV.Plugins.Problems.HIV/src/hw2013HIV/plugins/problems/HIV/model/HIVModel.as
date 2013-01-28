package hw2013HIV.plugins.problems.HIV.model
{
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.Record;
	import collaboRhythm.shared.model.RecurrenceRule;
	import collaboRhythm.shared.model.healthRecord.CodedValue;
	import collaboRhythm.shared.model.healthRecord.DocumentBase;
	import collaboRhythm.shared.model.healthRecord.ValueAndUnit;
	import collaboRhythm.shared.model.healthRecord.document.MedicationFill;
	import collaboRhythm.shared.model.healthRecord.document.MedicationOrder;
	import collaboRhythm.shared.model.healthRecord.document.MedicationScheduleItem;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemBase;
	import collaboRhythm.shared.model.services.ICurrentDateSource;
	import collaboRhythm.shared.model.services.WorkstationKernel;

	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	import mx.collections.ArrayCollection;

	public class HIVModel
	{
		private var _hivMedicationsArrayCollection:ArrayCollection;
		private var _record:Record;
		private var _activeRecordAccount:Account;
		private var _currentDateSource:ICurrentDateSource;
		private var _changeWatchers:Vector.<ChangeWatcher> = new Vector.<ChangeWatcher>();
		private var _medicationOrder:MedicationOrder;
		private var _medicationScheduleItem:MedicationScheduleItem;
		private var _medicationFill:MedicationFill;

		public function HIVModel(activeRecordAccount:Account)
		{
			_hivMedicationsArrayCollection = new ArrayCollection();

			var hivMedication:MedicationOrder = new MedicationOrder();
			hivMedication.name = new CodedValue("http://rxnav.nlm.nih.gov/REST/rxcui/", "639888", null,
					"emtricitabine 200 MG / Tenofovir disoproxil fumarate 300 MG Oral Tablet [Truvada]");

			_hivMedicationsArrayCollection.addItem(hivMedication);

			_activeRecordAccount = activeRecordAccount;
			_record = activeRecordAccount.primaryRecord;

			_currentDateSource = WorkstationKernel.instance.resolve(ICurrentDateSource) as ICurrentDateSource;
		}

		public function get hivMedicationsArrayCollection():ArrayCollection
		{
			return _hivMedicationsArrayCollection;
		}

		public function set hivMedicationsArrayCollection(value:ArrayCollection):void
		{
			_hivMedicationsArrayCollection = value;
		}

		public function scheduleMedication(medicationOrder:MedicationOrder):void
		{
			_medicationOrder = medicationOrder;

			medicationOrder.orderType = "Self-prescribed";
			medicationOrder.orderedBy = _activeRecordAccount.accountId;
			medicationOrder.dateOrdered = _currentDateSource.now();

			_medicationFill = new MedicationFill();
			_medicationFill.name = medicationOrder.name;
			_medicationFill.filledBy = _activeRecordAccount.accountId;
			_medicationFill.dateFilled = _currentDateSource.now();


			_medicationScheduleItem = new MedicationScheduleItem();
			_medicationScheduleItem.name = medicationOrder.name;
			_medicationScheduleItem.scheduledBy = _activeRecordAccount.accountId;
			_medicationScheduleItem.dateScheduled = _currentDateSource.now();
			_medicationScheduleItem.dateStart = new Date(_currentDateSource.now().fullYear,
					_currentDateSource.now().month, _currentDateSource.now().date, 8, 0, 0);
			_medicationScheduleItem.dateEnd = new Date(_currentDateSource.now().fullYear,
					_currentDateSource.now().month, _currentDateSource.now().date, 12, 0, 0);
			var recurrenceRule:RecurrenceRule = new RecurrenceRule();
			recurrenceRule.frequency = new CodedValue(null, null, null, ScheduleItemBase.DAILY);
			recurrenceRule.count = 90;
			_medicationScheduleItem.recurrenceRule = recurrenceRule;
			_medicationScheduleItem.dose = new ValueAndUnit("1", new CodedValue(null, null, null, "tablet"), "1");

			_changeWatchers.push(BindingUtils.bindSetter(medicationScheduleItemId_changeHandler,
					_medicationScheduleItem.meta, "id"));

			_record.addDocument(_medicationOrder, true);
			_record.addDocument(_medicationFill, true);
			_record.addDocument(_medicationScheduleItem, true);
		}

		private function medicationScheduleItemId_changeHandler(value:String):void
		{
			if (value)
			{
				_medicationOrder.medicationFill = _medicationFill;
				_record.addRelationship(MedicationOrder.RELATION_TYPE_MEDICATION_FILL,
						_medicationOrder, _medicationFill, true);

				_medicationScheduleItem.scheduledMedicationOrder = _medicationOrder;
				_medicationOrder.scheduleItems[_medicationScheduleItem.meta.id] = _medicationScheduleItem;
				_record.addRelationship(ScheduleItemBase.RELATION_TYPE_SCHEDULE_ITEM,
						_medicationOrder, _medicationScheduleItem, true);

				_record.saveAllChanges();
			}
		}
	}
}

package hw2013HIV.plugins.problems.HIV.controller
{
	import collaboRhythm.shared.collaboration.model.CollaborationLobbyNetConnectionServiceProxy;
	import collaboRhythm.shared.collaboration.model.SynchronizationService;
	import collaboRhythm.shared.controller.apps.AppControllerBase;
	import collaboRhythm.shared.controller.apps.AppControllerConstructorParams;
	import collaboRhythm.shared.model.healthRecord.document.MedicationOrder;

	import hw2013HIV.plugins.problems.HIV.model.HIVModel;

	import hw2013HIV.plugins.problems.HIV.view.HIVButtonWidgetView;
	import hw2013HIV.plugins.problems.HIV.view.HIVView;

	import mx.core.UIComponent;

	public class HIVAppController extends AppControllerBase
	{
		public static const DEFAULT_NAME:String = "HIV";

		private var _widgetView:HIVButtonWidgetView;

		private var _model:HIVModel;
		private var _collaborationLobbyNetConnectionServiceProxyLocal:CollaborationLobbyNetConnectionServiceProxy;
		private var _synchronizationService:SynchronizationService;

		public function HIVAppController(constructorParams:AppControllerConstructorParams)
		{
			super(constructorParams);

			_collaborationLobbyNetConnectionServiceProxyLocal = _collaborationLobbyNetConnectionServiceProxy as
					CollaborationLobbyNetConnectionServiceProxy;
			_synchronizationService = new SynchronizationService(this,
					_collaborationLobbyNetConnectionServiceProxyLocal);
		}

		override public function initialize():void
		{
			super.initialize();
			initializeHIVModel();

			updateWidgetViewModel();
		}

		private function initializeHIVModel():void
		{
			if (_model == null)
			{
				_model = new HIVModel(_activeRecordAccount);
			}
		}

		override protected function createWidgetView():UIComponent
		{
			initializeHIVModel();

			_widgetView = new HIVButtonWidgetView();
			return _widgetView;
		}

		override public function reloadUserData():void
		{
			removeUserData();

			super.reloadUserData();
		}

		override protected function updateWidgetViewModel():void
		{
			super.updateWidgetViewModel();

			if (_widgetView && _activeRecordAccount)
			{
				_widgetView.init(this, _model);
			}
		}

		public override function get defaultName():String
		{
			return DEFAULT_NAME;
		}

		override public function get widgetView():UIComponent
		{
			return _widgetView;
		}

		override public function set widgetView(value:UIComponent):void
		{
			_widgetView = value as HIVButtonWidgetView;
		}

		override public function get isFullViewSupported():Boolean
		{
			return false;
		}

		override protected function get shouldShowFullViewOnWidgetClick():Boolean
		{
			return false;
		}

		protected override function removeUserData():void
		{
			_model = null;
			// unregister any components in the _componentContainer here, such as:
			// _componentContainer.unregisterServiceType(IIndividualMessageHealthRecordService);
		}

		public function showHIVView():void
		{
			if (_synchronizationService.synchronize("showHIVView"))
			{
				return;
			}

			_viewNavigator.pushView(HIVView, this);
		}

		override public function close():void
		{
			if (_synchronizationService)
			{
				_synchronizationService.removeEventListener(this);
				_synchronizationService = null;
			}

			super.close();
		}

		public function get model():HIVModel
		{
			return _model;
		}

		public function scheduleMedication(medicationOrder:MedicationOrder):void
		{
			_model.scheduleMedication(medicationOrder);
		}
	}
}

package collaboRhythm.tablet.controller
{

	import collaboRhythm.core.controller.ApplicationControllerBase;
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.VideoMessage;
	import collaboRhythm.shared.model.settings.Settings;
	import collaboRhythm.shared.view.CollaborationView;
	import collaboRhythm.tablet.view.ActiveRecordView;
	import collaboRhythm.tablet.view.VideosView;

	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;

	import flash.events.KeyboardEvent;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;

	import mx.core.IVisualElementContainer;

	import spark.components.Application;

	public class TabletApplicationController extends ApplicationControllerBase
	{
		private const VIDEOS_VIEW:String = "Videos View";

		private var _application:Application;
		private var _tabletAppControllersMediator:TabletAppControllersMediator;
		private var _fullContainer:IVisualElementContainer;
		private var _widgetsContainer:IVisualElementContainer;
		private var _scheduleWidgetContainer:IVisualElementContainer;
		private var _activeRecordView:ActiveRecordView;
		private var _videosView:VideosView;
		private var _currentView:String;

		[Embed("/resources/settings.xml", mimeType="application/octet-stream")]
		private var _applicationSettingsEmbeddedFile:Class;

		public function TabletApplicationController(application:Application)
		{
			_application = application;
		}

		public override function main():void
		{
			super.main();

			_settings.modality = Settings.MODALITY_TABLET;

			initCollaborationController(null);

			createSession();
		}

		public override function openRecordAccount(recordAccount:Account):void
		{
			super.openRecordAccount(recordAccount);
			_activeRecordView = new ActiveRecordView();
			_activeRecordView.init(this, recordAccount);
			_application.addElement(_activeRecordView);
		}

		// the apps are not actually loaded immediately when a record is opened
		// only after the active record view has been created are they loaded, this makes the UI more responsive
		public function activeRecordView_creationCompleteHandler(recordAccount:Account):void
		{
			_fullContainer = _activeRecordView.fullViewsGroup;
			_tabletAppControllersMediator = new TabletAppControllersMediator(_activeRecordView.scheduleWidgetGroup,
																			 _activeRecordView.bloodPressureWidgetGroup,
																			 _fullContainer,
																			 _settings,
																			 _componentContainer);
			_tabletAppControllersMediator.createTabletApps(_activeAccount, recordAccount);
			loadDocuments(recordAccount);
		}

		public function openVideosView(recordAccount:Account):void
		{
			_videosView = new VideosView();
			_videosView.init(this, recordAccount);
			_activeRecordView.fullViewsGroup.addElement(_videosView);
			_currentView = VIDEOS_VIEW;
		}

		public override function get fullContainer():IVisualElementContainer
		{
			return _fullContainer;
		}

		public override function get applicationSettingsEmbeddedFile():Class
		{
			return _applicationSettingsEmbeddedFile;
		}

		public function deleteVideoMessage(videoMessage:VideoMessage):void
		{
			_activeRecordAccount.primaryRecord.videoMessagesModel.deleteVideoMessage(videoMessage);
			if (_activeRecordAccount.primaryRecord.videoMessagesModel.videoMessagesCollection.length == 0)
			{
				_activeRecordView.fullViewsGroup.removeElement(_videosView);
			}
		}

		public function get activeRecordView():ActiveRecordView
		{
			return _activeRecordView;
		}
	}
}
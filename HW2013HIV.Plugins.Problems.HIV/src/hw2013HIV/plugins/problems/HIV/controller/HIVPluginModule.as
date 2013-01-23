package hw2013HIV.plugins.problems.HIV.controller
{
	import castle.flexbridge.reflection.ReflectionUtils;

	import collaboRhythm.plugins.schedule.shared.model.IHealthActionCreationControllerFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputControllerFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionListViewAdapterFactory;
	import collaboRhythm.shared.controller.apps.AppControllerInfo;
	import collaboRhythm.shared.model.services.IComponentContainer;
	import collaboRhythm.shared.pluginsSupport.IPlugin;
	import collaboRhythm.shared.ui.healthCharts.model.modifiers.IChartModifierFactory;

	import mx.modules.ModuleBase;

	public class HIVPluginModule extends ModuleBase implements IPlugin
	{
		public function HIVPluginModule()
		{
			super();
		}

		public function registerComponents(componentContainer:IComponentContainer):void
		{
			// TODO: each plugin should register one or more of the following components; implement or delete the code below as appropriate; using the CollaboRhythm file templates in IntelliJ IDEA may make this easier
			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(HIVAppController).name,
					AppControllerInfo,
					new AppControllerInfo(HIVAppController));

//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(HIVHealthActionListViewAdapterFactory).name,
//					IHealthActionListViewAdapterFactory,
//					new HIVHealthActionListViewAdapterFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(HIVHealthActionInputControllerFactory).name,
//					IHealthActionInputControllerFactory,
//					new HIVHealthActionInputControllerFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(HIVChartModifierFactory).name,
//					IChartModifierFactory,
//					new HIVChartModifierFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(HIVHealthActionCreationControllerFactory).name,
//					IHealthActionCreationControllerFactory,
//					new HIVHealthActionCreationControllerFactory());
		}
	}
}

"""
-----
AntonVK: http://anton.koudinov.ru, mailto:anton@koudinov.ru
-----
"""
#
import os
import re
#
from frameworks.wulf import WindowLayer
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, ScopeTemplates
from gui.Scaleform.framework.entities.abstract.AbstractViewMeta import AbstractViewMeta
from gui.Scaleform.framework.entities.View import View
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.shared import events
from gui.shared import g_eventBus, EVENT_BUS_SCOPE
from gui.shared.personality import ServicesLocator

class hangarClockAnalog(View, AbstractViewMeta):

	def __init__(self):
		View.__init__(self)

	def _populate(self):
		View._populate(self)

	def _dispose(self):
		View._dispose(self)

	def py_log(self, text):
		print('[hangarClockAnalog]: %s' % text)

	def py_getWoTPath(self):
		__WoT__ = os.path.dirname(os.path.abspath(__file__))
		__WoT__ = __WoT__[0:__WoT__.rfind('scripts')]
		__WoT__ = re.sub(r"(win\d*)([\\]*)", "", __WoT__)
		return __WoT__

_windowAlias = 'hangarClockAnalog'
_url = 'hangarClockAnalog.swf'
_type = WindowLayer.WINDOW
_event = None
_scope = ScopeTemplates.GLOBAL_SCOPE

_settings = ViewSettings(_windowAlias, hangarClockAnalog, _url, _type, _event, _scope)
g_entitiesFactories.addSettings(_settings)

def onAppInitializing(event):
    if event.ns == APP_NAME_SPACE.SF_LOBBY:
        app = ServicesLocator.appLoader.getApp(event.ns)
        if app:
            app.loadView(SFViewLoadParams(_windowAlias))


g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZING, onAppInitializing)

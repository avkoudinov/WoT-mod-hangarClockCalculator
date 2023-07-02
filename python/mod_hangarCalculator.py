"""
-----
AntonVK: http://anton.koudinov.ru, mailto:anton@koudinov.ru
-----
"""
#
from frameworks.wulf import WindowLayer
from gui.Scaleform.daapi import LobbySubView
from gui.Scaleform.daapi.view.meta.WindowViewMeta import *
from gui.Scaleform.framework import g_entitiesFactories, ViewSettings, ScopeTemplates
from gui.Scaleform.framework.entities.View import View
from gui.shared import events

LobbySubView.__background_alpha__ = 0

class hangarCalculator(LobbySubView, WindowViewMeta):

	def __init__(self):
		View.__init__(self)

	def _populate(self):
		View._populate(self)

	def _dispose(self):
		View._dispose(self)

	def onTryClosing(self):
		return True

	def onWindowClose(self):
		self.destroy()

	def py_log(self, text):
		print('[hangarCalculator]: %s' % text)

_windowAlias = 'hangarCalculator'
_url = 'hangarCalculator.swf'
_type = WindowLayer.WINDOW
_event = None
_scope = ScopeTemplates.DEFAULT_SCOPE

_settings = ViewSettings(_windowAlias, hangarCalculator, _url, _type, _event, _scope)
g_entitiesFactories.addSettings(_settings)

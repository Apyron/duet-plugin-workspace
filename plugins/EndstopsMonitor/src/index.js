'use strict'

import { registerSettingTab } from 'dwc/routes'

import EndstopsMonitor from './EndstopsMonitor.vue'

registerSettingTab(false, 'Endstops', EndstopsMonitor, 'Endstops');

'use strict'

import { registerSettingTab } from 'dwc/routes'

import TestView from './TestView.vue'

registerSettingTab(false, 'TestPlugin', TestView, 'TestPlugin');

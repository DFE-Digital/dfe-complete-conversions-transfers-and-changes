import { ApplicationInsights } from '@microsoft/applicationinsights-web'
import { ClickAnalyticsPlugin } from '@microsoft/applicationinsights-clickanalytics-js'

const applicationInsightsConnectionString = document.head.querySelector('meta[name="application-insights-connection"]').content

const clickPluginInstance = new ClickAnalyticsPlugin()
const clickPluginConfig = {
  autoCapture: true
}

const appInsights = new ApplicationInsights({
  config: {
    connectionString: applicationInsightsConnectionString
  },
  extensions: [clickPluginInstance],
  extensionConfig: {
    [clickPluginInstance.identifier]: clickPluginConfig
  }
}
)

appInsights.loadAppInsights()
appInsights.trackPageView()

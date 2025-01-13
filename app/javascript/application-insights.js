import { ApplicationInsights } from '@microsoft/applicationinsights-web'
import { ClickAnalyticsPlugin } from '@microsoft/applicationinsights-clickanalytics-js'

window.addEventListener('DOMContentLoaded', () => {
  const applicationInsightsConnectionString = document.head.querySelector('meta[name="application-insights-connection"]').content

  const clickPluginInstance = new ClickAnalyticsPlugin()
  const clickPluginConfig = {
    autoCapture: true
  }

  const appInsights = new ApplicationInsights({
    config: {
      connectionString: applicationInsightsConnectionString,
      autoTrackPageVisitTime: true
    },
    extensions: [clickPluginInstance],
    extensionConfig: {
      [clickPluginInstance.identifier]: clickPluginConfig
    }
  }
  )

  const currentUserIdentifier = () => {
    const currentUser = document.querySelector('#current-user')

    return currentUser.dataset.identifier
  }

  appInsights.loadAppInsights()
  appInsights.setAuthenticatedUserContext(currentUserIdentifier(), null, true)
  appInsights.trackPageView()
})

/* eslint-disable no-undef */
window.onload = function () {
  window.ui = SwaggerUIBundle({
    url: '/api/swagger.json',
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: 'StandaloneLayout'
  })
}
/* eslint-enable no-undef */
# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.script_src :self,
      "www.googletagmanager.com"
    policy.connect_src :self,
      "region1.google-analytics.com",
      "https://js.monitor.azure.com",
      "https://westeurope-5.in.applicationinsights.azure.com"
  end
end

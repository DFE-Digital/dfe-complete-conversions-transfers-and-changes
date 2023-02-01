# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, "https://region1.google-analytics.com"
    policy.font_src :self
    policy.img_src :self, "https://region1.google-analytics.com"
    policy.object_src :none
    policy.script_src :self, "https://www.googletagmanager.com/gtm.js"
    policy.style_src :self
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap and inline scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src]

  #   # Report violations without enforcing the policy.
  #   # config.content_security_policy_report_only = true
end

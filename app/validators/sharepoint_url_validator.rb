class SharepointUrlValidator < ActiveModel::EachValidator
  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)

    record.errors.add(attribute, :https_only) unless uri.scheme == "https"
    record.errors.add(attribute, :host_not_allowed) unless SHAREPOINT_URLS.include?(uri.hostname)
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid)
  end
end

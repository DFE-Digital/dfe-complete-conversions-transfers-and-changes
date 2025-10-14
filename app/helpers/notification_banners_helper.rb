module NotificationBannersHelper
  def hide_flash_banner_for_current_path?
    patterns = [
      'projects/**/tasks',
      'projects/**/tasks/**',
      'projects/**/notes',
      'projects/**/notes/**'
    ]

    RouteMatch.new(route: request.path, matching_patterns: patterns).match?
  end
end



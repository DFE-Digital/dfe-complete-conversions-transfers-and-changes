class Api::AcademiesApi::CachedConnection
  def initialize(
    api_connection:,
    cache_keyer: Api::AcademiesApi::CacheKeyer,
    cache: Rails.cache,
    logger: Rails.logger
  )
    @api_connection = api_connection
    @cache_keyer = cache_keyer
    @cache = cache
    @logger = logger
  end

  def fetch(path:, params: nil)
    key = @cache_keyer.for_path(path: path, params: params)
    hit = @cache.read(key)
    log_hit_or_miss(hit, key, path, params)
    return hit if hit.present?

    fresh_value = fresh_value_for(path, params)
    @cache.write(key, fresh_value, expires_in: 24.hours)

    fresh_value
  end

  private def fresh_value_for(path, params)
    if params
      @api_connection.get(path, params)
    else
      @api_connection.get(path)
    end
  end

  private def log_hit_or_miss(hit, key, path, params)
    hit_or_miss = hit ? "Hit" : "Miss"
    params_if_present = params ? "params: #{params}" : ""
    details = "for #{key} [path: #{path} #{params_if_present}]"

    @logger.info "#{hit_or_miss} #{details}"
  end
end

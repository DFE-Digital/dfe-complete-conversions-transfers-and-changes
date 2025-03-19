class Api::AcademiesApi::CacheKeyer
  class << self
    def for_path(path:, params: nil)
      Digest::SHA1.hexdigest([path, params].compact.join(" "))
    end
  end
end

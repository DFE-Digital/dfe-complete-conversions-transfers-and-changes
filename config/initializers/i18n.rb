if Rails.env.test?
  I18n.exception_handler = proc do |exception, *_|
    raise exception.to_exception
  end
end

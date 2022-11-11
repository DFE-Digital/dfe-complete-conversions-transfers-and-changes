module MultiparameterDate
  ACCEPTABLE_YEAR_RANGE = 2000..3000

  private def date_from_multiparameter_hash(hash)
    Date.new(year_for(hash), month_for(hash), day_for(hash))
  rescue ArgumentError
    hash
  end

  private def date_parameter_valid?(param)
    day_parameter_valid?(day_for(param)) &&
      month_parameter_valid?(month_for(param)) &&
      year_parameter_valid?(year_for(param))
  end

  private def day_parameter_valid?(param)
    (1..31).to_a.include?(param)
  end

  private def month_parameter_valid?(param)
    (1..12).to_a.include?(param)
  end

  private def year_parameter_valid?(param)
    ACCEPTABLE_YEAR_RANGE.to_a.include?(param)
  end

  private def day_for(value)
    value[3]
  end

  private def month_for(value)
    value[2]
  end

  private def year_for(value)
    value[1]
  end
end

class AcademiesApi::BaseApiModel
  include ActiveModel::Serializers::JSON

  class AttributeMapMissingError < RuntimeError; end

  def from_hash(hash)
    self.attributes = hash.stringify_keys
    self
  end

  def attributes=(hash)
    self.class.attribute_map.each do |attribute_name, access_path|
      split_access_path = access_path.split(".")
      value = hash.with_indifferent_access.dig(*split_access_path)
      next if value.nil?

      send("#{attribute_name}=", value)
    end
  end

  def self.attribute_map
    raise AttributeMapMissingError, ".attribute_map hasn't been overridden"
  end
end

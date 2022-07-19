class AcademiesApi::BaseApiModel
  include ActiveModel::Serializers::JSON

  class AttributeMapMissingError < RuntimeError; end

  def from_hash(hash)
    self.attributes = hash.stringify_keys
    self
  end

  def attributes=(hash)
    hash.each do |key, value|
      next unless self.class.attribute_map.value?(key)

      attribute_name = self.class.attribute_map.key(key)
      send("#{attribute_name}=", value)
    end
  end

  def self.attribute_map
    raise AttributeMapMissingError, ".attribute_map hasn't been overridden"
  end
end

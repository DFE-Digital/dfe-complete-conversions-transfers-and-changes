class Ops::DbAvailability
  def self.db_available?
    return true if User.first && ActiveRecord::Base.connected?
    false
  end
end

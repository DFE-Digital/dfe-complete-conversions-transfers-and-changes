class Ops::DbAvailability
  def self.db_available?
    begin
      return true if User.first && ActiveRecord::Base.connected?
    rescue ActiveRecord::ConnectionNotEstablished
      return false
    end

    false
  end
end

class CorrectSupportGrantTypes < ActiveRecord::Migration[7.0]
  def up
    Conversion::TasksData.all.each do |tasks_data|
      case tasks_data.sponsored_support_grant_type
      when "fast-track"
        tasks_data.update_attribute(:sponsored_support_grant_type, "fast_track")
      when "full-sponsored"
        tasks_data.update_attribute(:sponsored_support_grant_type, "full_sponsored")
      end
    end
  end

  def down
    Conversion::TasksData.all.each do |tasks_data|
      case tasks_data.sponsored_support_grant_type
      when "fast_track"
        tasks_data.update_attribute(:sponsored_support_grant_type, "fast-track")
      when "full_sponsored"
        tasks_data.update_attribute(:sponsored_support_grant_type, "full-sponsored")
      end
    end
  end
end

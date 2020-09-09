class AddShowTimeToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :show_time, :datetime
    Match.all.each do |match|
      match.update show_time: match.start_time - 30.minutes
    end
  end
end

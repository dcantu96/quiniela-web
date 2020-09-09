class AddOrderToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :order, :integer

    Tournament.all.each do |tournament|
      tournament.weeks.each do |week|
        week.matches.order(start_time: :asc).each_with_index do |match, index|
          match.update order: index + 1
        end
      end
    end
  end
end

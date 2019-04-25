class AddColumnToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :guest_can_book_before, :string
  end
end

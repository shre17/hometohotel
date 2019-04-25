class AddColumnToExperiences < ActiveRecord::Migration[5.2]
  def change
    add_column :experiences, :curreny, :string
  end
end

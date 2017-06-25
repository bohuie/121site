class AddLabToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :lab_id, :integer
  end
end

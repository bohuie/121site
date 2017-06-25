class RemovePracticeIdFromPractices < ActiveRecord::Migration
  def change
    remove_column :practices, :practice_id, :integer
  end
end

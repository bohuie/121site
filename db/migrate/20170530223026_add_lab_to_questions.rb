class AddLabToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :lab_id, :integer
  end
end

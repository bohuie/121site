class RemoveOldColumnsFromQuestion < ActiveRecord::Migration
  def change
    remove_column :questions, :lab, :string
    remove_column :questions, :fname, :string
    remove_column :questions, :lname, :string
    remove_column :questions, :studentnumber, :integer
    remove_column :questions, :course_id, :integer
  end
end

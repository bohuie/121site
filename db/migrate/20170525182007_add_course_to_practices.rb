class AddCourseToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :course_id, :integer
  end
end

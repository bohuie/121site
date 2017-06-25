class AddCourseCreatedInIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :course_created_in_id, :integer
  end
end

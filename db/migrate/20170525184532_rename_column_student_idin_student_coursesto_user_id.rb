class RenameColumnStudentIdinStudentCoursestoUserId < ActiveRecord::Migration
  def change
  	rename_column :student_courses, :student_id, :user_id
  end
end

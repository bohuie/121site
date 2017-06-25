class AddCourseToResults < ActiveRecord::Migration
  def change
    add_column :results, :course_id, :integer
  end
end

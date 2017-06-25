class RemoveCourseFromTopic < ActiveRecord::Migration
  def change
    remove_column :topics, :course_id, :integer
  end
end

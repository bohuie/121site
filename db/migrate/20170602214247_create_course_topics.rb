class CreateCourseTopics < ActiveRecord::Migration
  def change
    create_table :course_topics do |t|
      t.integer :course_id
      t.integer :topic_id

      t.timestamps null: false
    end
  end
end

class RenameColumnStudentIdInStudentLabsToUserId < ActiveRecord::Migration
  def change
  	rename_column :student_labs, :student_id, :user_id
  end
end

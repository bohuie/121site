class RemoveTopicFromPractice < ActiveRecord::Migration
  def change
    remove_column :practices, :topic_id, :integer
  end
end

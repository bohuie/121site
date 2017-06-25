class RemoveTopicIdFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :topic_id, :integer
  end
end

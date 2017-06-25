class RemoveAssistantFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :assistant, :boolean
  end
end

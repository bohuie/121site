class RemoveLabFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lab, :string
  end
end

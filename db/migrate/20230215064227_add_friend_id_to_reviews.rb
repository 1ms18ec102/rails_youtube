class AddFriendIdToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :friend_id, :integer
    add_index :reviews, :friend_id
  end
end

class ChangeUserIdNoteOptional < ActiveRecord::Migration[6.0]
  def change
    change_column :notes, :user_id, :bigint, optional: false
  end
end

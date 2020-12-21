class ChangeFKsNoteOptional < ActiveRecord::Migration[6.0]
  def change
    change_column :notes, :user_id, :bigint, optional: true
    change_column :notes, :book_id, :bigint, optional: true
  end
end

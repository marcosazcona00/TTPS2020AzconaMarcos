class ChangeFkBook < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :user_id, :bigint, null: false
  end
end

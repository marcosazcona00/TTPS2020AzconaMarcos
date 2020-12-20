class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, limit: 50, null: false
      
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end

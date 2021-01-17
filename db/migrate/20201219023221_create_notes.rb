class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :title, limit: 50, null: false
      t.text :content, null: false
      t.belongs_to :user, foreign_key: true
      t.belongs_to :book, foreign_key: true


      t.timestamps
    end
  end
end

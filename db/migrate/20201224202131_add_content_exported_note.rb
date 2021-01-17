class AddContentExportedNote < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :exported_content, :text
  end
end

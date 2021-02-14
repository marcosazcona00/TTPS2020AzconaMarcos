class DeleteExportedContentNote < ActiveRecord::Migration[6.0]
  def change
    remove_column :notes, :exported_content
  end
end

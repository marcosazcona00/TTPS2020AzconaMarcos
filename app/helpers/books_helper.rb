module BooksHelper
    def export_helper(t_export, extension)
        require 'zip'
        zipped_content = Zip::OutputStream.write_buffer do |file|
            t_export.each do |note|
                file.put_next_entry("#{note.title}.#{extension}")
                file << note.content_to_html
            end
        end
        zipped_content.rewind
        return zipped_content
    end
end

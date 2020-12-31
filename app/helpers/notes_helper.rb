module NotesHelper
    def validate_note_id
        note_id = params[:id]
        if !note_id.nil?
            ### Si no llego nil, significa que no es el cajon global
            ### Verificamos si existe
            begin
                @note = Note.find(note_id)
            rescue ActiveRecord::RecordNotFound
                redirect_to '/'
                return
            end
        end
    end
end

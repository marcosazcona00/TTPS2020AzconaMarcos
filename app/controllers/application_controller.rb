class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    
    def validate_book_id
        id_book = params[:id_book]
        if !id_book.nil? and id_book.to_i != 0 
            ### Si no llego nil como tampoco 0 significa que no es el cajon global
            ### Verificamos si existe
            begin
                @book = current_user.get_book(id: id_book)
            rescue ActiveRecord::RecordNotFound
                redirect_to '/'
                return false
            end
        end
        return true
    end
    
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

class NotesController < ApplicationController
    def index
        id_book = params[:id]
        @notes = current_user.get_notes_book(id_book)
    end

    def new
        @note = Note.new
    end

    def create
        title =  params[:note][:title]
        content =  params[:note][:content]

        ### Si el parametro que recibi es 0 es porque debemos guardarlo en el global, por lo que intercambiamos 0 por nil
        book_id = if params[:id].to_i == 0 then nil else params[:id] end
        
        @note = Note.new(title: title, content: content, book_id: book_id, user_id: current_user.id)
        #if book_id.nil?
        #    ### Si no recibimos el libro, entonces asignamos la nota al usuario directamente. Caso contrario queda asociado al libro
        #    @note.user_id = current_user.id
        #end
        if @note.save
            redirect_to '/books'
            return
        end
        render 'new'
        
    end
end

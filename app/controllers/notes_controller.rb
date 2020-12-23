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
        ### La idea es, si va en el global, el libro es nil y se pone el id del usuario logueado
        ### Caso contrario, la nota va en un cuaderno, el book_id se pone como vino y el id del usuario se deja en nil
        book_id = if params[:id].to_i == 0 then nil else params[:id] end
        
        @note = Note.new(title: title, content: content, book_id: book_id, user_id: current_user.id)
        
        if @note.save
            redirect_to '/books'
            return
        end
        render 'new'
    end

    def edit
        note_id = params[:id]
        begin 
            @note = Note.find(note_id)
            @current_note = Note.find(note_id)
        rescue ActiveRecord::RecordNotFound 
            ### TODO redireccionar a un 403
            redirect_to '/'
            return
        end
    end

    def update
        note_id = params[:id]
        @current_note = Note.find(note_id)
        new_title = params[:note][:title]
        new_content = params[:note][:content]

        if @current_note.update(title: new_title,content: new_content)
            redirect_to '/books'
            return
        end
        #@current_book.errors = book_modify.errors
        @note = Note.find(note_id)
        render 'edit'
    end 
end

class NotesController < ApplicationController
    def index
    end

    def new
        ### Esto es lo que le llega al html
        puts 'Parametros new ',params
        @note = Note.new
        @books = current_user.books
    end

    def create
        puts 'Parametros Create',params
        title =  params[:note][:title]
        content =  params[:note][:content]

        ### Si el parametro que recibi es 0 es porque debemos guardarlo en el global, por lo que intercambiamos 0 por nil
        book_id = if params[:id].to_i == 0 then nil else params[:id] end
        @note = Note.new(title: title, content: content, book_id: book_id)
        if @note.save
            redirect_to '/books'
            return
        end
        render 'new'
        
    end
end

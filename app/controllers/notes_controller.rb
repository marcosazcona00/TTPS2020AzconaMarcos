class NotesController < ApplicationController
    before_action :set_book, except: [:edit, :update, :detroy, :export]
    before_action :set_note, except: [:index, :new, :create]
        
    def show
    end

    def index
        @id_book = params[:id_book]
        #@notes = current_user.get_notes_book(@id_book) 
        @notes = current_user.get_notes_book(@id_book).page(params[:page])
        @total_pages = @notes.page().total_pages

    end

    def new
        @id_book = params[:id_book]
        @note = Note.new
    end

    def create
        title =  params[:note][:title]
        content =  params[:note][:content]
        book_id = params[:id_book]

        @note = Note.new(title: title, content: content, book_id: book_id, user_id: current_user.id)  
        if @note.save
            flash[:notice] = "The note #{@note.title} has been created succesfully"
            redirect_to action: 'index', id_book: book_id 
            return
        end
        ### Reinicializamos el valor de @id_book porque se pierde
        @id_book = book_id
        
        ### Al hacer el POST, en algunos casos el render pierde el id_book, por lo que lo pasamos explicitamente
        render 'new', :id_book => @id_book
    end

    def edit
        note_id = params[:id]
        @current_note = Note.find(note_id)
    end

    def update
        note_id = params[:id]
        @current_note = Note.find(note_id)
        new_title = params[:note][:title]
        new_content = params[:note][:content]
        
        if @current_note.update(title: new_title,content: new_content)
            flash[:notice] = "The note #{@current_note.title} has been updated succesfully"

            redirect_to action: 'index', id_book: @current_note.book_id 
            return
        end

        ### Reinstanciamos la nota para editarla
        @note = Note.find(note_id)
        render 'edit'
    end 
    
    def destroy
        book_id = @note.book_id
        @note.destroy
        flash[:notice] = "The note #{@note.title} has been deleted succesfully"
        redirect_to action: 'index', id_book: book_id
    end

    def export
        @note.export
        flash[:notice] = "The note #{@note.title} has been exported succesfully"

        redirect_to action: 'index', id_book: @note.book_id 
    end

    def set_note
        note_id = params[:id]
        @note = current_user.get_note(note_id)
    end
end

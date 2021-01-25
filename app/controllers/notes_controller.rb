class NotesController < ApplicationController
    before_action :set_book, except: [:edit, :update, :detroy, :export]
    before_action :set_note, except: [:index, :new, :create]
    before_action :set_id_book, only: [:index, :new]

    def show
    end

    def index
        @notes = current_user.get_notes_book(params[:id_book]).page(params[:page])
        @total_pages = @notes.page().total_pages
    end

    def new
        @note = Note.new
    end

    def create
        title =  params[:note][:title]
        content =  params[:note][:content]
        @id_book = params[:id_book]

        @note = Note.new(title: title, content: content, book_id: @id_book, user_id: current_user.id)  
        if @note.save
            flash[:notice] = "The note #{@note.title} has been created succesfully"
            redirect_to action: 'index', id_book: @id_book
            return
        end
        ### Reinicializamos el valor de @id_book porque se pierde
        @book = current_user.get_book(id: @id_book)
        
        ### Al hacer el POST, en algunos casos el render pierde el id_book, por lo que lo pasamos explicitamente
        render 'new', :id_book => @id_book
    end

    def edit
        @current_note = @note
    end

    def update
        note_id = params[:id]
        new_title = params[:note][:title]
        new_content = params[:note][:content]
        
        if @note.update(title: new_title,content: new_content)
            flash[:notice] = "The note #{@note.title} has been updated succesfully"

            redirect_to action: 'index', id_book: @note.book_id 
            return
        end

        # Reinstanciamos la nota para no perder la informacion original de la nota
        @current_note = Note.find(note_id)
        render 'edit'
    end 
    
    def destroy
        @note.destroy
        flash[:notice] = "The note #{@note.title} has been deleted succesfully"
        redirect_to action: 'index', id_book: @note.book_id
    end

    def download
        @note.export
        send_data @note.exported_content, :filename => "#{@note.title}.html"
    end

    def export
        @note.export
        flash[:notice] = "The note #{@note.title} has been exported succesfully"
        redirect_to action: 'show', id_book: @note.book_id 
    end

    def set_note
        note_id = params[:id]
        @note = current_user.get_note(note_id)
    end

    
    def set_id_book
        @id_book = if !@book.nil? then @book.id else nil end
    end
end

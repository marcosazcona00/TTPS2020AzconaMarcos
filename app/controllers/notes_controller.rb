class NotesController < ApplicationController
    before_action :set_book, except: [:edit, :update, :detroy, :export]
    before_action :set_note, except: [:index, :new, :create]
    # before_action :set_id_book, only: [:new]

    def show
    end

    def index
        @notes = current_user.get_notes_book(params[:id_book]).page(params[:page])
        @total_pages = @notes.page().total_pages
    end

    def new
        @id_book = if !@book.nil? then @book.id else nil end
        @note = Note.new
    end

    def create
        @id_book = params[:id_book]
        @note = Note.new(note_params)
        @note.user = current_user
        @note.book_id = @id_book

        if @note.save
            flash[:notice] = "The note #{@note.title} has been created succesfully"
            redirect_to action: 'index', id_book: @id_book
            return
        end
        
        # Reinicializamos book. Si el cuaderno es el global, reinicializamos a nil. En caso contrario, obtenemos el cuaderno.
        @book = if @id_book.nil? then nil else current_user.books.find(@id_book) end

        ### Al hacer el POST, en algunos casos el render pierde el id_book, por lo que lo pasamos explicitamente
        render 'new', :id_book => @id_book
    end

    def edit
        @current_note = @note
    end

    def update
        note_id = params[:id]        
        if @note.update(title: note_params[:title],content: note_params[:content])
            flash[:notice] = "The note #{@note.title} has been updated succesfully"

            redirect_to action: 'show', id_book: @note.book_id 
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

    def export
        @note.content_to_html
        send_data @note.exported_content, :filename => "#{@note.title}.html"
    end

    def set_note
        note_id = params[:id]
        @note = current_user.notes.find(note_id)
    end
    
    # def set_id_book
    #     @id_book = if !@book.nil? then @book.id else nil end
    # end

    private
    def note_params
        params.require(:note).permit(:title, :content)
    end
end

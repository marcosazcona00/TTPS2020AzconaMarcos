class BooksController < ApplicationController    
    before_action :set_book, except: [:index, :new, :create, :export_all, :export]

    def index
        @books = current_user.books.page(params[:page])
        @total_pages = @books.page().total_pages
    end

    def new
        @book = Book.new
    end

    def create
        book_values = params[:book]
        @book = Book.new(title: book_values[:title], user_id: current_user.id)
        if @book.save
            flash[:notice] = "The book #{@book.title} has been created succesfully"
            redirect_to action: 'index'
            return  
        end
        render 'new'
    end

    def edit
        #current_book representa el libro no modificado
        @current_book = @book
    end

    def update
        book_id = params[:id_book]
        new_title =  params[:book][:title]
        if @book.update(title: new_title)
            flash[:notice] = "The book #{@book.title} has been updated succesfully"
            redirect_to action: 'index'
            return
        end
        # Como no pudo actualizarse pero el book cambia de todas formas, reseteamos el current book
        @current_book = current_user.get_book(id: book_id)
        render 'edit'
    end 

    def destroy
        puts 'Destroy'
        if params[:id_book].to_i == 0
            # Borramos las notas del cuaderno global
            current_user.delete_global_notes()
            flash[:notice] = "The notes of global book has been deleted succesfully"
        else
            @book.destroy
            flash[:notice] = "The book #{@book.title} has been deleted succesfully"
        end
        redirect_to action: 'index'
    end

    def export
        id_book = params[:id_book]        
        if id_book.to_i == 0
            # Si el id_book es 0 significa que se exporta del global
            current_user.export_global
            flash[:booknotice] = "The global book has been exported succesfully"
        else
            self.set_book()
            @book.export
            flash[:notice] = "The book #{@book.title} has been exported succesfully"
        end
        redirect_to action: 'index'
    end

    def export_all
        flash[:notice] = "All books has been exported succesfully"
        current_user.export_all
        redirect_to action: 'index'
    end
end

class BooksController < ApplicationController    
    #after_action :validate_pagination
    before_action :validate_book_id

    def index
        @books = current_user.books
        #@books = current_user.books.page(params[:page])
        #@total_pages = @books.page().total_pages
    end

    def new
        ### Esto es lo que le llega al html
        @book = Book.new
    end

    def create
        book_values = params[:book]
        @book = Book.new(title: book_values[:title], user_id: current_user.id)
        if @book.save
            ### La creacion fue exitosa
            redirect_to action: 'index'
            return  
        end
        ### La creacion no pudo realizarse
        render 'new'
    end

    def edit
        ### Validamos que en el id no venga ningun simbolo extra
        book_id = params[:id_book]
        @current_book = current_user.get_book(id: book_id)
        if @current_book.nil?
            ### Redirigir a un forbbidden 400 porque el libro no lo tiene
            redirect_to '/'
            return            
        end
    end

    def update
        book_id = params[:id_book]
        @current_book = current_user.get_book(id: book_id)
        new_title =  params[:book][:title]
        if @current_book.update(title: new_title)
            redirect_to action: 'index'
            return
        end
        #@current_book.errors = book_modify.errors
        @book = current_user.get_book(id: book_id)
        render 'edit'
    end 

    def destroy
        @book.destroy
        redirect_to action: 'index'
    end

    def export
        id_book = params[:id_book]        
        if id_book.to_i == 0
            ### Si el id_book es 0 significa que se exporta del global
            current_user.export_global
        else
            @book.export
        end
    end

    def export_all
        current_user.export_all
    end
end

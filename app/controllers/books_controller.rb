class BooksController < ApplicationController
    include ApplicationHelper
    
    ### Con esto verificamos si a este controlador ingresa un usuario autenticado
    
    def index
        @books = current_user.books
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
        book_id = params[:id]
        if valid_id?(book_id)
            ### Redirigiar a un 400 Bad Request    
            redirect_to '/'
            return
        end
        @book = current_user.get_book(id: book_id)
        @current_book = current_user.get_book(id: book_id)
        if @current_book.nil?
            ### Redirigir a un forbbidden 400 porque el libro no lo tiene
            redirect_to '/'
            return            
        end
    end

    def update
        book_id = params[:id]
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
        book_id = params[:id]
        if valid_id?(book_id)
            ### Redirigiar a un 400 Bad Request    
            redirect_to '/'
            return
        end
        @book = current_user.get_book(id: book_id)
        @book.destroy
        redirect_to action: 'index'
    end
end

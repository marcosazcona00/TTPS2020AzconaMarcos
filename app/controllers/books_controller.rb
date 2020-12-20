class BooksController < ApplicationController
    ### Con esto verificamos si a este controlador ingresa un usuario autenticado
    before_action :authenticate_user!
    
    def new
        ### Esto es lo que le llega al html
        @book = Book.new
    end

    def create
        book_values = params[:book]
        @book = Book.create(title: book_values[:title], user_id: current_user.id)
        if @book.valid?
            ### La creacion fue exitosa
            redirect_to '/'
            return
        end
        ### La creacion no pudo realizarse
        render 'new'
    end

    def edit
        puts params
    end

    def update
    end

end

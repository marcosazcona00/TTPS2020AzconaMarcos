class BooksController < ApplicationController    
    before_action :set_book, except: [:index, :new, :create, :export_all, :export]

    def index
        @books = current_user.books.page(params[:page])
        @total_pages = @books.page().total_pages
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
            flash[:notice] = "The book #{@book.title} has been created succesfully"
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
            flash[:notice] = "The book #{@current_book.title} has been updated succesfully"
            redirect_to action: 'index'
            return
        end
        #@current_book.errors = book_modify.errors
        @book = current_user.get_book(id: book_id)
        render 'edit'
    end 

    def destroy
        @book.destroy
        flash[:notice] = "The book #{@book.title} has been deleted succesfully"
        redirect_to action: 'index'
    end

    def export
        id_book = params[:id_book]        
        if id_book.to_i == 0
            ### Si el id_book es 0 significa que se exporta del global
            current_user.export_global
            flash[:notice] = "The global book has been exported succesfully"
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

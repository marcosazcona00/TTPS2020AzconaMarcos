require 'zip'

class BooksController < ApplicationController    
    include BooksHelper
    before_action :set_book, except: [:index, :new, :create, :export_all, :export]

    def index
        @books = current_user.books.page(params[:page])
        @total_pages = @books.page().total_pages
    end

    def new
        @book = Book.new
    end

    def create        
        @book = Book.new(book_params)
        @book.user = current_user
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
        if @book.update(book_params)
            flash[:notice] = "The book #{@book.title} has been updated succesfully"
            redirect_to action: 'index'
            return
        end
        # Como no pudo actualizarse pero el book cambia de todas formas, reseteamos el current book
        @current_book = current_user.books.find(book_id)
        render 'edit'
    end 

    def destroy
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
        if id_book.nil?
            notes_to_export = current_user.global_notes()
            book_title = 'Global'
        else
            self.set_book()
            notes_to_export = @book.notes
            book_title = @book.title
        end

        if !notes_to_export.empty?
            zipped_content = export_helper(notes_to_export, 'html')
            send_data zipped_content.sysread, filename: "#{book_title}.zip", :type => 'application/zip'
        else
            flash[:notice] = 'The book that you try to export is empty'
            return redirect_to action: 'index'
        end
    end

    def export_all
        has_exported = false
        compiled_book = Zip::OutputStream.write_buffer do |zip_book|
            current_user.books.each do |book|
                if !book.notes.empty?
                    has_exported = true
                    zipped_content = export_helper(book.notes, 'html')
                    zip_book.put_next_entry("#{book.title}.zip")
                    zip_book << zipped_content.sysread
                end
                
            end
            if !current_user.global_notes.empty?
                has_exported = true
                zipped_content = export_helper(current_user.global_notes, 'html')
                zip_book.put_next_entry("Global.zip")
                zip_book << zipped_content.sysread
            end
        end
        if has_exported
            compiled_book.rewind
            send_data compiled_book.sysread, filename: "exported_books.zip", :type => 'application/zip'
        else
            flash[:notice] = 'Nothin exported'
            return redirect_to action: 'index'
        end
    end

    private
    def book_params
        params.require(:book).permit(:title)
    end
end

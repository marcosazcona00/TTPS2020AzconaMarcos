module BooksHelper
    def validate_book_id
        id_book = params[:id_book]
        if !id_book.nil?
            ### Si no llego nil, significa que no es el cajon global
            ### Verificamos si existe
            begin
                @book = current_user.get_book(id: id_book)
            rescue ActiveRecord::RecordNotFound
                puts 'ERROR 400 Forbidden'
                redirect_to '/'
                return false
            end
        end
        return true
    end
end

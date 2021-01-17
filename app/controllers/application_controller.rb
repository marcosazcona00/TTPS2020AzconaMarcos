class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    after_action :validate_page_number!, only: [:index]

    def set_book 
        ### Esto si falla tira un 404 en produccion
        id_book = params[:id_book]
        if !id_book.nil? and id_book.to_i != 0     
            @book = current_user.get_book(id: id_book)
        end
    end
    
    def validate_page_number!
        page_number = params[:page].to_i
        
        if page_number > @total_pages.to_i
            raise ActionController::RoutingError.new('Not Found')
        end
    end
end

module ApplicationHelper
    def valid_id?(id)
        return /^[0-9]+/.match(id).nil?
    end

    def validate_pagination
        puts 'Pagina ',params[:page]
        puts 'Total ',@total_pages
    end
end

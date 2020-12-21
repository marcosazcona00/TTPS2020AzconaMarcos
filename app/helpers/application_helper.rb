module ApplicationHelper
    def valid_id?(id)
        return /^[0-9]+/.match(id).nil?
    end
end

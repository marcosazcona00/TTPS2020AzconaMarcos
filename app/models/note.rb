class Note < ApplicationRecord
    belongs_to :user, optional: false
    belongs_to :book, optional: true

    before_validation :strip_whitespaces
    validates :content, presence: true 

    # ---> Sacar con una migracion el content_exported.

    ### Con este uniqueness validamos que la nota para un usuario en uno de sus libros no exista
    ###:uniqueness => {case_sensitive: true, :scope => [:user, :book]}
    validates :title, presence: true, length: { maximum: 50 }, :uniqueness => {case_sensitive: false, :scope => [:user, :book]}

    def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end

    def content_to_html 
        return Kramdown::Document.new(content).to_html
    end
end

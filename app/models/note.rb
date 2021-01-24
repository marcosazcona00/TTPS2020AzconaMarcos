class Note < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :book, optional: true

    before_validation :strip_whitespaces
    validates :content, presence: true 

    ### Con este uniqueness validamos que la nota para un usuario en uno de sus libros no exista
    ###:uniqueness => {case_sensitive: true, :scope => [:user, :book]}
    validates :title, presence: true, length: { maximum: 50 }, :uniqueness => {case_sensitive: false, :scope => [:user, :book]}

    def initialize(args)
        if !args.nil?
            if !args[:book_id].nil?
                args[:user_id] = nil
            end
        end
        super
    end

    def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end

    def export
        new_exported_content = Kramdown::Document.new(content).to_html
        self.exported_content = new_exported_content
        self.save()
    end
end

class Book < ApplicationRecord
    ### El dependen permite borrar en cascada
    has_many :notes, :dependent => :delete_all 
    belongs_to :user
    
    #El scope parece que se fija si para ese usuario, ese titulo existe.
    validates :title, presence: true, length: { maximum: 50 }, uniqueness: {case_sensitive: false, scope: :user}
    
    before_validation :strip_whitespaces

    def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end

 
    def export
        notes.each { |note| note.export}
    end

    def has_note?(note_title)
        ### Este metodo verifica si, dentro de un libro, existe una nota
        return notes.exists?(title: note_title)
    end

end

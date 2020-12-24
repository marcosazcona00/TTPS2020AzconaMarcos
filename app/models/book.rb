class Book < ApplicationRecord
    ### El dependen permite borrar en cascada
    has_many :notes, :dependent => :delete_all 
    belongs_to :user
    
    #El scope parece que se fija si para ese usuario, ese titulo existe.
    validates :title, presence: true, length: { maximum: 50 }, uniqueness: { scope: :user} 
    
    before_validation :strip_whitespaces

    ### Esta validacion corre solo en la creacion
    #validate :already_exists_on_creation?, :on => [:create]

    ### Esta validacion corre solo en el update
    #validate :already_exists_on_update?, :on => [:update_attribute]

    #def already_exists_on_creation?
    #    if owner().get_book(title: title)
    #        ### Si existe el libro
    #        errors[:exists] << 'This book already exists'
    #    end
    #end 

    def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end

    def owner
        return User.find_by(id: user_id)
    end

    def export
        notes.each { |note| note.export}
    end

    def has_note?(note_title)
        ### Este metodo verifica si, dentro de un libro, existe una nota
        return notes.exists?(title: note_title)
    end

end

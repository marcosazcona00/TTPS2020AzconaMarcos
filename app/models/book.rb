class Book < ApplicationRecord
    has_many :notes

    validates :title, presence: true, length: { maximum: 50 }
    
    ### Esta validacion corre solo en la creacion
    validate :already_exists_on_creation?, :on => [:create]
    
    #validate :already_exists_update?, :on => [:update]


    def owner
        return User.find_by(id: user_id)
    end

    def already_exists_on_creation?
        if owner().exists_title_book?(title)
            errors[:exists] << 'This book already exists'
        end
    end 

    def has_note?(note_title)
        ### Este metodo verifica si, dentro de un libro, existe una nota
        return notes.exists?(title: note_title)
    end

end

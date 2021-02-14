class Book < ApplicationRecord
    ### El dependent permite borrar en cascada
    has_many :notes, :dependent => :delete_all 
    belongs_to :user
    
    #El scope parece que se fija si para ese usuario, ese titulo existe.
    validates :title, presence: true, length: { maximum: 50 }, uniqueness: {case_sensitive: false, scope: :user}
    
    before_validation :strip_whitespaces
    
    validate :has_global_name?, on: [:create, :update] 

    def has_global_name?
        # Valida que el global book ya no exista
        if title.downcase == 'global'
            errors.add(:title, "has already been taken ")
        end
    end

    def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end
 
    def export
        notes.each { |note| note.export}
    end
end

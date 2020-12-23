class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :books
  has_many :notes
  ### notes representa las notas que estan en el "global"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def get_book(args)
    '''
      Devuelve la instancia de un libro
    '''
    return books.find_by(**args)
  end

  def get_notes_book(book_id)
    if book_id.nil?
      return self.notes
    end
    return self.get_book(id: book_id).notes
  end
end

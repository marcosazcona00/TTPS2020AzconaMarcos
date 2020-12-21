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

  def has_new_book?(old_title,new_title)
      '''
        Verifica que el libro existente y el nuevo libro modificado sean distintos
        True si el libro ya existia.
        False si es el mismo libro (no cambio) o el libro no existe 
      '''
      book_new_title = get_book(title: new_title)
      if book_new_title.nil?
        return false
      end
      return get_book(title: old_title) != get_book(title: new_title)
    end
end

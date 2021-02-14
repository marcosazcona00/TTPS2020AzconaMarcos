class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :books
  has_many :notes, dependent: :destroy
  ### notes representa las notas que estan en el "global"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  

  def global_notes
    # Devuelve las notas que no tienen asociadas un cuaderno
    return self.notes.where(book_id: nil)
  end

  def get_notes_book(book_id)
    # Devuelve las notas de un cuaderno particular
    if book_id.nil?
      return self.global_notes()
    end
    return self.books.find(book_id).notes
  end

  def export_global
    self.global_notes().each { |note| note.export }
  end

  def delete_global_notes()
    self.global_notes().delete_all
  end

  def export_all
    books.each { |book| book.export}
    self.export_global()
  end
end

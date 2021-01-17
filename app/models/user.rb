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
    book = books.find_by(**args)
    if !book.nil?
      return book
    else
      raise ActiveRecord::RecordNotFound 
    end
  end

  def get_notes_book(book_id)
    if book_id.nil?
      return self.notes
    end
    return self.get_book(id: book_id).notes
  end

  def export_global
    notes.each { |note| note.export }
  end

  def export_all
    books.each { |book| book.export}
    notes.each { |note| note.export}
  end

  def get_note(note_id)
    note = notes.find_by(id: note_id) ### Nos fijamos entre las notas del cuaderno global
    if note.nil?
      ### Si no esta en el global, buscamos entre los cuadernos creados por el usuario.
      
      ### Devuelve la instancia del cuaderno que tenga la nota. Si la nota no existe para ese usuario, retorna nil
      book = books.select { |book| book.has_note?(note_id)}[0] 
      if !book.nil?
        note = book.get_note(note_id)
      else
        raise ActiveRecord::RecordNotFound 
      end
    end
    return note
  end
end

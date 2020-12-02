module RN
    class NoteModel
        include Configuration

        attr_accessor :title, :book, :path_book, :path_file, :extension


        def initialize(book,title = '', extension = 'rn')
            self.title = title
            self.book = book
            self.path_book = ""
            self.path_file = ""
            self.extension = ".#{extension}"
        end

        def validate_book
            if !self.book.nil? and self.book.strip.empty?
                return false, 'El parametro cuaderno no puede ser vacio'
            end
                                
            self.path_book = if self.book.nil? then self.relative_path else self.relative_path(self.book) end
            if !Dir.exist?(self.path_book)
                return false, "El cuaderno '#{book}' no existe"
            end

            #Defino la ruta del archivo en caso de ser valido el book
            begin
                self.path_file = File.join(self.path_book, self.title + self.extension)
            rescue
                #Esta excepcion se generara cuando exportemos y no ingresemos un titulo, por lo que el titulo sera nil
            end 
            return true
        end

        def create
            is_valid_book, msg = self.validate_book()
            if !is_valid_book
                return msg
            end

            if !self.validate_filename(self.title)
                return "El nombre de la nota #{title} no es valido"
            end

            if File.exist?(self.path_file)
                return "La nota '#{self.title}' ya existe"
            end

            TTY::Editor.open(self.path_file)
            return "La nota #{self.title} ha sido creada exitosamente"
        end
 
        def delete
            is_valid_book, msg = self.validate_book()
            if !is_valid_book
                return msg 
            end

            if !File.exist?(self.path_file)
                return "La nota '#{self.title}' que desea eliminar no existe"
            end

            File.delete(self.path_file)
            return "Borrado exitosamente la nota '#{self.title}'"
        end

        def retitle(new_title)
            is_valid_book, msg = self.validate_book()
            if !is_valid_book
                return msg
            end
                
            if !self.validate_filename(new_title)
                return "El nombre de la nota '#{new_title}' no es valido"
            end
                
            path_new_file = File.join(self.path_book, new_title + self.extension)
            if File.exist?(path_new_file)
                return "La nota '#{new_title}' que desea renombrar ya existe"
            end

            if !File.exist?(self.path_file)
                return "La nota '#{self.title}' que desea renombrar no existe"
            end

            File.rename(self.path_file,path_new_file)

            #Actualizamos la información de la nueva nota
            self.title = new_title
            self.path_file = path_new_file
                
            return "Nota '#{self.title}' renombrada como '#{new_title}' exitosamente"
        end

        def edit
            is_valid_book, msg = self.validate_book()
            if !is_valid_book
                return msg 
            end
                
            
            if !File.exist?(self.path_file)
                return "La nota '#{self.title}' que desea editar no existe"
            end

            TTY::Editor.open(path_file)
            return "Edita exitosamente la nota '#{title}'"
        end

        def show
            is_valid_book, msg = self.validate_book()
            if !is_valid_book
                return msg 
            end
            
            puts self.path_file
            
            if !File.exist?(self.path_file)
                warn "La nota '#{self.title}' que desea mostrar no existe"
                return
            end
            return File.read(self.path_file)
        end

        def notes
            """
                Devuelve las notas de un libro
            """
            return Dir.entries(self.path_book).select do |file|
                !File.directory?(File.join(self.path_book,file)) and File.extname(file) == '.rn' 
            end
        end

        def list_notes_book
            is_valid_book, msg = self.validate_book()
            if !is_valid_book
                return msg, false 
            end
            return self.notes(),true      
        end

        def list_global()
            self.path_book = self.relative_path #Seteamos como path_book el del cuaderno global
            return self.notes()

        end

        def all_notes()
            books = BookModel.new().books()
            notes = {}            
            books.each do |book|
                self.path_book = self.relative_path(book) 
                notes[book] = notes()
            end
            
            #Como no existe el cuaderno global como cuaderno no puedo hacer esto debido a que puede haber un cuaderno que se llame asi
            #notes['Notas del Cuaderno Global'] = self.list_global()
            return notes
        end

        #Se podria extraer la responsabilidad de Exportar a una Clase Export que permita exportar notas y/o libros
        def export_file(note, book = '')
            '''
                Exporta una nota en especifico
            '''
            path_file = File.join(self.relative_path(book),note)
            rich_text_file = path_file.gsub('.rn','.html')
            file = File.open(path_file)
            new_file_content = Kramdown::Document.new(file.read).to_html
            
            File.open(rich_text_file, 'w') { |f| f.write new_file_content}
        end

        def export_notes(notes,book = '')
            '''
                Exporta un conjunto de notas
            '''
            notes.each do |note| 
                rich_text_file = File.join(self.relative_path,note.gsub('.rn','.html'))
                export_file(note,book)
            end
        end

        def export_global
            '''
                Exporta las notas del global
            '''
            rn_notes = self.notes().select do |note| 
                File.extname(note) == '.rn'
            end
            export_notes(rn_notes)
        end

        def export_notes_books
            '''
                Exporta las notas de los cuadernos
            '''
            books = Book::BookModel.books(self.relative_path)
            
            books.each do |book|
                self.path_book = self.relative_path(book)
                rn_notes = self.notes().select {|note| File.extname(note) == '.rn'}
                export_notes(rn_notes,book)
            end
        end
            
        def export
            if !self.book.nil? or !self.title.nil?
                #Verificar si es valido
                is_valid_book, msg = self.validate_book()
                if !is_valid_book
                    return msg 
                end
                
                if !self.title.nil?
                    #Exportamos una nota particular
                    if !File.exist?(self.path_file)
                        return "La nota '#{self.title}' que desea exportar no existe"
                    end
                    self.book = if self.book.nil? then '' else self.book end
                    self.export_file(self.title + self.extension,self.book)
                    return "Exportada la nota #{self.title} exitosamente"
                end

                if !self.book.nil?
                    notes,is_valid = list_notes_book()
                    self.export_notes(self.notes(),self.book)
                    return "Exportada las notas del libro #{self.book}"
                end
            end
            
            self.path_book = self.relative_path
            export_global()
            export_notes_books()            
        end
    end
end
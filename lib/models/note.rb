module RN
    module Note
        require 'rn/configuration'
        
        class NoteModel
            extend Configuration
            
            @@path_book = ""
            @@path_file = ""

            def self.file_path(title)
                return File.join(@@path_book, title += '.rn')
            end

            def self.validate_book(book)
                if !book.nil? and book.strip.empty?
                    #Si viene un string vacio no deberia permitir crear nada
                    raise Errno::BookParameterEmpty
                end
                                
                @@path_book = if book.nil? then self.relative_path else self.relative_path(book) end
                if !Dir.exist?(@@path_book)
                    raise Errno::ENOENT
                end
            end

            def self.create(title,**options)
                book = options[:book]
                
                begin
                    validate_book(book)  
                rescue Errno::BookParameterEmpty => error
                    puts error
                    return
                rescue Errno::ENOENT 
                    puts "El cuaderno '#{book}' no existe"
                    return
                end
                
                if !self.validate_filename(title)
                    warn "El nombre de la nota #{title} no es valido"
                    return
                end

                puts file_path(title)
                path_file = file_path(title)
                
                if File.exist?(path_file)
                    warn "La nota '#{title}' ya existe"
                    return
                end

                TTY::Editor.open(path_file)

            end

            def self.delete(title,**options)
                book = options[:book]
                puts "Delete"
                #TODO borrar una nota. Si no viene el book, se borra del global. Si viene el book se borra del book
                begin
                    validate_book(book)  
                rescue Errno::BookParameterEmpty => error
                    puts error
                    return
                rescue Errno::ENOENT 
                    puts "El cuaderno '#{book}' no existe"
                    return
                end
                
                path_file = file_path(title)
                puts path_file
                if !File.exist?(path_file)
                    warn "La nota '#{title}' que desea eliminar no existe"
                    return
                end

                File.delete(path_file)
                puts "Borrado exitosamente la nota '#{title}'"
            end

            def self.retitle(old_title,new_title,options)
                book = options[:book]
                puts book
                puts 'Retitle'
                begin
                    validate_book(book)  
                rescue Errno::BookParameterEmpty => error
                    puts error
                    return
                rescue Errno::ENOENT 
                    puts "El cuaderno '#{book}' no existe"
                    return
                end
                
                                
                if !self.validate_filename(new_title)
                    warn "El nombre de la nota '#{new_title}' no es valido"
                    return
                end

                path_new_file = file_path(new_title)
                if File.exist?(path_new_file)
                    warn "La nota '#{new_title}' que desea renombrar ya existe"
                    return
                end

                path_old_file = file_path(old_title)
                if !File.exist?(path_old_file)
                    warn "La nota '#{old_title}' que desea renombrar no existe"
                    return
                end

                File.rename(path_old_file,path_new_file)
                puts "Nota '#{old_title}' renombrada como '#{new_title}' exitosamente"
                
            end

            def self.edit(title,**options)
                book = options[:book]
                puts "Edito"
                #TODO borrar una nota. Si no viene el book, se borra del global. Si viene el book se borra del book
                begin
                    validate_book(book)  
                rescue Errno::BookParameterEmpty => error
                    puts error
                    return
                rescue Errno::ENOENT 
                    puts "El cuaderno '#{book}' no existe"
                    return
                end
                
                path_file = file_path(title)
                puts path_file
                if !File.exist?(path_file)
                    warn "La nota '#{title}' que desea editar no existe"
                    return
                end

                TTY::Editor.open(path_file)
                puts "Edita exitosamente la nota '#{title}'"
            end

            def self.show(title,**options)
                book = options[:book]
                begin
                    validate_book(book)  
                rescue Errno::BookParameterEmpty => error
                    puts error
                    return
                rescue Errno::ENOENT 
                    puts "El cuaderno '#{book}' no existe"
                    return
                end
                
                path_file = file_path(title)
                if !File.exist?(path_file)
                    warn "La nota '#{title}' que desea mostrar no existe"
                    return
                end
                puts '****Contenido Nota*****'
                File.foreach(path_file) do |line|
                    puts line
                end  
            end

            def self.notes(book)
                notes = Dir.entries(book).select do |file|
                    !File.directory?(File.join(book,file))
                end
                notes.each do |note|
                    puts "--> #{note}"
                end.empty? and begin
                    puts 'No hay notas'
                end
            end

            def self.list_global()
                puts '**Cajon global de notas**'
                notes(self.relative_path) #Lista las notas del global
            end

            def self.list_all_notes()
                puts '**********Cuadernos*************'
                books = Book::BookModel.books(self.relative_path)
                books.each do |book|
                    puts "*****#{book}******"
                    notes(self.relative_path(book))
                end
            end

            def self.list(options)
                book = options[:book]
                global = options[:global]
                
                begin
                    validate_book(book)    
                rescue Errno::BookParameterEmpty => error
                    puts error
                    return
                rescue Errno::ENOENT 
                    puts "El cuaderno '#{book}' no existe"
                    return
                end
                
                if global
                    list_global()
                    return
                end

                if book.nil?
                    #Imprimimos todo lo que hay
                    list_global()
                    list_all_notes()
                else
                    puts "*****#{book}******"
                    notes(@@path_book)  
                end
            end

            private_class_method :file_path, :validate_book, :list_global, :notes, :list_all_notes

        end
    end
end
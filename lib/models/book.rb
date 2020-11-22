module RN
    module Book
        require 'fileutils'
        require 'rn/configuration'
        
        class BookModel
            extend Configuration
            def self.create(name, **kwargs)
                if !self.validate_filename(name)
                    warn "El nombre del cuaderno #{name} no es valido"
                    return
                end
                begin
                    Dir.mkdir(self.relative_path(name))
                rescue Errno::EEXIST 
                    puts "El cuaderno #{name} ya existe"
                else
                    puts "El cuaderno #{name} fue creado exitosamente"
                end
            end

            def self.list()
                if Dir.empty?(self.relative_path)
                    warn "Aun no hay cuadernos "
                    return
                end
                puts '--Listado Cuadernos--'

                books(self.relative_path).each do |file|
                  if ['.','..'].include?(file)
                    next
                  end
                  puts '--> ' + file
                end
                puts '--Fin Listado Cuadernos--'
            end
        
            def self.rename(old_name,new_name)
                if Dir.exist?(self.relative_path(new_name))
                    warn "El cuaderno '#{new_name}' ya existe"
                    return
                end
                if !self.validate_filename(new_name)
                    warn "El nombre del cuaderno #{new_name} no es valido"
                    return
                end

                begin
                    File.rename(self.relative_path(old_name),self.relative_path(new_name))
                rescue Errno::ENOENT  
                    warn "El cuaderno que quiere renombrar '#{old_name}' no existe"
                else
                    warn "El cuaderno '#{old_name}' ha sido renombrado como '#{new_name}' correctamente"
                end
            end
            
            def self.books(book)
                books = Dir.entries(book).select do |file|
                    File.directory?(File.join(book,file)) and !(['.','..'].include?(file))
                end
                return books
            end

            def self.delete_files(dir_path)
                Dir.foreach(dir_path) do |file|
                  if ['.','..'].include?(file)
                    next
                  end
                  File.delete(File.join(dir_path,file))
                end
              end
      
            
              def self.delete_book(book)
                books(book).each do |dir|    
                    path_book = File.join(book,dir)
                    delete_files(path_book)
                end
                FileUtils.rm_rf(book)
            end

            def self.delete(name,global)
                if global
                    if books(self.relative_path).empty?
                        warn "El cuaderno global no tiene cuadernos"
                    else
                        delete_book(self.relative_path)
                        warn 'El contenido del cuaderno global fue borrado exitosamente'
                        return
                    end
                end

                if !name.nil?
                    path_book = File.join(self.relative_path,name)
                    if !Dir.exist?(path_book)
                        warn "El cuaderno '#{name}' no existe"
                        return
                    end
                    delete_book(path_book)
                    warn "El cuaderno #{name} fue borrado exitosamente"
                end
            end

            private_class_method :delete_files, :delete_book
        end
    end
end 
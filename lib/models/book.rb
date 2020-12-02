module RN
    require 'fileutils'
    class BookModel
        include Configuration

        attr_accessor :title
        
        def initialize(title = '')
            self.title = title
        end

        def create
            puts "Create"
            if !self.validate_filename(self.title)
                return "El nombre del cuaderno '#{self.title}' no es valido"
            end
            begin
                Dir.mkdir(self.relative_path(self.title))
            rescue Errno::EEXIST 
                return "El cuaderno '#{self.title}' ya existe"
            else
                return "El cuaderno '#{self.title}' fue creado exitosamente"
            end
        end
        
        def books
            '''
                Devuelve los cuadernos de un cuaderno
            '''
            book = self.relative_path
            books = Dir.entries(book).select do |file|
                File.directory?(File.join(book,file)) and !(['.','..'].include?(file))
            end
            return books
        end

        def rename(new_name)
            if Dir.exist?(self.relative_path(new_name))
                return "El cuaderno '#{new_name}' ya existe"
                
            end
            if !self.validate_filename(new_name)
                return "El nombre del cuaderno #{new_name} no es valido"
            end

            begin
                File.rename(self.relative_path(self.title),self.relative_path(new_name))
            rescue Errno::ENOENT  
                return "El cuaderno que quiere renombrar '#{self.title}' no existe"
            else
                self.title = new_name #Actualizamos el nombre del libro dentro de la instancia
                return "El cuaderno '#{self.title}' ha sido renombrado como '#{new_name}' correctamente"
            end
        end
        
        def delete_global
            self.books().each do |dir|
                FileUtils.rm_rf(self.relative_path(dir))
            end
        end 

        def delete(global)
            dir_path = self.relative_path(title)
            if !global
                if !Dir.exist?(dir_path)
                    return "El cuaderno '#{self.title}' no existe"
                end
                FileUtils.rm_rf(dir_path)
                return "El cauderno #{self.title} ha sido borrado exitosamente"
            end

            #Se pidio opcion global. Borramos del GLOBAL
            self.delete_global()
            return "Los cuadernos del cuaderno global fueron borrados exitosamente"
        end
    end
end

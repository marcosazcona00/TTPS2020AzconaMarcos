module Configuration
    def relative_path(name = '')
        return File.join(Dir.home, '.my_rns',name)
    end  

    def validate_filename(name)
        return (/[*?!|<>.|\/|\|\\|]+/.match(name)).nil?
    end

    class ConfigurationDirectory
        extend Configuration
        attr_accessor :relative_path
        
        def self.initialize_directory
            relative_path = ConfigurationDirectory.relative_path
            if !Dir.exist?(relative_path)
                Dir.mkdir(relative_path)
                Dir.mkdir(File.join(relative_path,'cuaderno global'))
            end
        end

    end

    class ConfigurationFile
        extend Configuration
        def self.file_relative_path(title, book = '')
            return File.join(ConfigurationFile.relative_path(book),title += '.rn')    
        end
    end

    class FileDirError < StandardError
        def initialize(message)
            super(message)
        end
    end

    module TemplateMethod 
        extend Configuration
    
        def template(title,**options)
            begin
                book = options[:book]
                book = if book.nil? then 'cuaderno global' else book end
                validation(title,book)
                dir_exist?(title,book)
                file_exist?(title,book)
                operation(title,book)
            rescue => error
                puts error
            end
        end

        def dir_exist?(title=nil,book)
            if !book.nil? and book == ''
                raise FileDirError.new("El cuaderno del parametro --book no puede ser vacio")
            end
            if !Dir.exist?(TemplateMethod.relative_path(book))
                raise FileDirError.new("El cuaderno '#{book}' no existe")
            end
        end	
        
        def file_exist?(title,book)
            "Override en caso de no querer utilizar esta funcionalidad"
            if File.exist?(Configuration::ConfigurationFile.file_relative_path(title, book))
                raise FileDirError.new("La nota '#{title}' ya existe dentro del cuaderno '#{book}'")
            end
        end
        
        def validation(title,book)
            "HOOK"
        end
        
        def operation(title,book)
            "HOOK"
        end       
    end


    module TemplateBook
        extend Configuration
        def template(title,**kwargs)
            global = kwargs.has_key?("global") ? kwargs[:global] : nil
            begin
                self.validation(title,global)
                self.dir_exist?(title)
                self.operation(title)
            rescue => error
                puts error
            end
        end

        def validation(title,global)
            if !global.nil? and global == ''
                raise FileDirError.new("El cuaderno del parametro --book no puede ser vacio")
            end
            if !TemplateBook.validate_filename(title)
                raise  FileDirError.new("El titulo del cuaderno #{title} no es valido")
            end
        end

        def dir_exist?(title)
            file_path = TemplateBook.relative_path(name)
            if !Dir.exist?(file_path)
              puts "El cuaderno #{name} no existe dentro del directorio #{file_path}"
              return 
            end
        end
    end
end
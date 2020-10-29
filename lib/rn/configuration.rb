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
            book = options[:book]
            book = if book.nil? then 'cuaderno global' else book end
            validation(title,book)
            dir_exist?(title,book)
            file_exist?(title,book)
            operation(title,book)
        end

        def dir_exist?(title,book)
            if !Dir.exist?(TemplateMethod.relative_path(book))
                raise FileDirError.new("El cuaderno '#{book}'' sobre el que quiere crear la nota '#{title}' no existe")
            end
        end	
        
        def file_exist?(title,book)
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

end
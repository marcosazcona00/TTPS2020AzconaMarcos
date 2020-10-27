module Configuration
    def relative_path(name = '')
        return File.join(Dir.home, '.my_rns',name)
    end  

    def validate_filename(name)
        return !((/[*?!|<>.]+/.match(name)).nil?)
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
end
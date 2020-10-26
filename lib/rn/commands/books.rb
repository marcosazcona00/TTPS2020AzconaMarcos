module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        attr_accessor :relative_path

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def initialize 
          self.relative_path = File.join(Dir.home, '.my_rns')
        end

        def call(name:, **kwargs)
          #Caracteres que hay que evitar que no puede llevar
          #\ / : * ? " < > |
          
          #TODO armar la expresion regular
          file_path = File.join(self.relative_path,name)
          if File.exist?(file_path)
            puts "El archivo #{name} ya existe dentro del directorio #{self.relative_path}"
            return 
          end
          
          "No existe el cuaderno, lo creamos"
          Dir.mkdir(file_path)
        end
      end

      class Delete < Dry::CLI::Command
        attr_accessor :relative_path
        
        desc 'Delete a book'
      
        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def initialize 
          self.relative_path = File.join(Dir.home, '.my_rns')
        end
      
        def delete_files(dir_path)
          Dir.foreach(dir_path) do |file|
            if file  == '.' or file == '..'
              next
            end
            File.delete(File.join(dir_path,file))
          end
        end

        def call(name: nil, **options)
          global = options[:global]

          if global
            dir_path = File.join(self.relative_path, 'cuaderno global')
            self.delete_files(dir_path)  
          end
          
          if name.nil?
            return 
          end

          dir_path = File.join(self.relative_path, name)
          if !File.exist?(dir_path)
            puts "El directorio #{name} no existe"
            return 
          end

          #Existe el directorio
          self.delete_files(dir_path)
        end
      
        private :delete_files
      end

      class List < Dry::CLI::Command
        attr_accessor :relative_path
        
        desc 'List books'

        example [
          '          # Lists every available book'
        ]
        
        def initialize 
          self.relative_path = File.join(Dir.home, '.my_rns')
        end
        
        def call(*)
          puts '---Listado Cuadernos---'
          Dir.foreach(self.relative_path) do |file|
            if ['.','..'].include?(file)
              next
            end
            puts '--> ' + file
          end
          puts '--Fin Listado Cuadernos--'
        end
      end

      class Rename < Dry::CLI::Command
        attr_accessor :relative_path
        
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def initialize 
          self.relative_path = File.join(Dir.home, '.my_rns')
        end

        def call(old_name:, new_name:, **)
          #Asumo que el nombre del cuaderno global no puede renombrar
          if old_name == 'cuaderno global'
            puts "El cuaderno global no puede ser renombrado"
            return
          end
          
          #Verificamos si el cuaderno que quiere renombrar existe
          old_name_path = File.join(self.relative_path, old_name)
          if !File.exist?(old_name_path)
            puts "El cuaderno que quiere renombrar con nombre '#{old_name}' no existe dentro del directorio"
            return
          end
          
          #Verificamos si no existe ya un cuaderno con el nuevo nombre
          new_name_path = File.join(self.relative_path, new_name)
          if File.exist?(new_name_path)
            puts "El cuaderno con el nombre #{new_name} ya existe dentro del directorio"
            return
          end

          File.rename(old_name_path,new_name_path)
        end
      end
    end
  end
end

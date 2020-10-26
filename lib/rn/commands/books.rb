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
          self.relative_path = ENV['HOME'] + '/' + '.my_rns' 
        end

        def call(name:, **kwargs)
          #Caracteres que hay que evitar que no puede llevar
          #\ / : * ? " < > |
          
          #TODO armar la expresion regular
          file_path = self.relative_path + '/' + name
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
          self.relative_path = ENV['HOME'] + '/' + '.my_rns' + '/'
        end
      
        def delete_files(dir_path)
          Dir.foreach(dir_path) do |file|
            if file == '.' or file == '..'
              next
            end
            File.delete(dir_path + '/' + file)
          end
        end

        def call(name: nil, **options)
          global = options[:global]
          #Si recibo global activo, borrar las notas del cuaderno global
          if global
            dir_path = self.relative_path  + 'cuaderno global'
            self.delete_files(dir_path)  
          end
          
          if name.nil?
            return 
          end

          dir_path = self.relative_path + name
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
          self.relative_path = ENV['HOME'] + '/' + '.my_rns' 
        end
        
        def call(*)
          puts '---Listado Cuadernos---'
          Dir.foreach(self.relative_path) do |file|
            if file == '.' or file == '..'
              next
            end
            
            puts '--> ' + file
          end
          puts '--Fin Listado Cuadernos--'
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          warn "TODO: Implementar renombrado del cuaderno de notas con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}." 
        end
      end
    end
  end
end

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
            return -1
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
      
        def call(name: nil, **options)
          #Si recibo el nombre, borrar ese directorio y todos sus archivos
          warn "TODO: Implementar borrado del cuaderno de notas con nombre '#{name}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          warn "TODO: Implementar listado de los cuadernos de notas.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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

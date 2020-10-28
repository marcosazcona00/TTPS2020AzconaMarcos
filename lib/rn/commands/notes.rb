require 'tty-editor'
module RN
  module Commands
    module Notes
      require 'rn/configuration'
      class Create < Dry::CLI::Command
        extend Configuration
        
        desc 'Create a note'
        
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'
        
        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]
        
        def call(title:, **options)
          book = options[:book]
          
          if !Create.validate_filename(title)
            puts "El nombre de la nota #{title} no es valido"
            return
          end
          
          book = if book.nil? then 'cuaderno global' else book end
          
          if !Dir.exist?(Create.relative_path(book))
            puts "El cuaderno '#{book}'' sobre el que quiere crear la nota '#{title}' no existe"
            return
          end

          if File.exist?(Configuration::ConfigurationFile.file_relative_path(title, book))
            puts "La nota '#{title}' ya existe dentro del cuaderno '#{book}'"
            return
          end

          #w+ es para escritura y lectura y lo crea vacio
          File.new(Configuration::ConfigurationFile.file_relative_path(title, book), "w+")
          
          #Abre un editor para poner el contenido del archivo
          TTY::Editor.open(Configuration::ConfigurationFile.file_relative_path(title, book))

        end
      end

      class Delete < Dry::CLI::Command
        extend Configuration

        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def delete_note(title, book)
          "Retorna un boolean indicando si pudo o no borrarse"
          if !File.exist?(Configuration::ConfigurationFile.file_relative_path(title,book))
            puts "La nota '#{title}' no existe dentro del '#{book}'"
            return
          end
          File.delete(Configuration::ConfigurationFile.file_relative_path(title,book))
          puts "Borrado exitosamente la nota '#{title}'  del cuaderno '#{book}"
        end

        def call(title:, **options)
          book = options[:book]
          if !book.nil? and book == ''
            puts "El parametro --books no puede ser vacio"
            return
          end

          if !Dir.exist?(Delete.relative_path(book))
            puts "El cuaderno '#{book}'' sobre el que quiere eliminar la nota '#{title}' no existe"
            return
          end

          book = if book.nil? then 'cuaderno global' else book end
          self.delete_note(title,book)
        end
      end

      class Edit < Dry::CLI::Command
        extend Configuration

        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          #TODO refactorizar con respecto al Delete. Tienen una estructura similar
          if !book.nil? and book == ''
            puts "El parametro --books no puede ser vacio"
            return
          end
          
          book = if book.nil? then 'cuaderno global' else book end
          
          if !Dir.exist?(Edit.relative_path(book))
            puts "El cuaderno '#{book}'' sobre el que quiere editar la nota '#{title}' no existe"
            return
          end

          if !File.exist?(Configuration::ConfigurationFile.file_relative_path(title,book))
            puts "La nota #{title} no existe"
            return
          end

          TTY::Editor.open(Configuration::ConfigurationFile.file_relative_path(title, book))
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          warn "TODO: Implementar cambio del título de la nota con título '#{old_title}' hacia '#{new_title}' (del libro '#{book}').\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          warn "TODO: Implementar listado de las notas del libro '#{book}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if !book.nil? and book == ''
            puts "El parametro --books no puede ser vacio"
            return
          end
          
          book = if book.nil? then 'cuaderno global' else book end
          
          if !Dir.exist?(Edit.relative_path(book))
            puts "El cuaderno '#{book}'' sobre el que quiere mostrar la nota '#{title}' no existe"
            return
          end

          if !File.exist?(Configuration::ConfigurationFile.file_relative_path(title,book))
            puts "La nota '#{title}' no existe dentro del cuaderno '#{book}'"
            return
          end
          puts "---Contenido Nota #{title}---"
          File.foreach(Configuration::ConfigurationFile.file_relative_path(title,book)) do |line|
            puts line
          end
        end      
      end
    end
  end
end

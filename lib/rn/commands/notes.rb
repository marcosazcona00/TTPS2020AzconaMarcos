require 'tty-editor'
module RN
  module Commands
    module Notes
      require 'rn/configuration'
      class Create < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateFile

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        desc 'Create a note'
      
        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoitleires"'
        ]

        def validation(title,book)
          if !Create.validate_filename(title)
            raise Configuration::FileDirError.new("El nombre de la nota #{title} no es valido")
          end
        end
        
        def operation(title,book)
          #w+ es para escritura y lectura y lo crea vacio
          File.new(Configuration::ConfigurationFile.file_relative_path(title, book), "w+")
          
          #Abre un editor para poner el contenido del archivo
          TTY::Editor.open(Configuration::ConfigurationFile.file_relative_path(title, book))
        end    
      
        def call(title:, **options)
          self.template(title,**options)
        end
      end
    
      class Delete < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateFile

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
            raise Configuration::FileDirError.new("La nota '#{title}' no existe dentro del '#{book}'")
          end
          File.delete(Configuration::ConfigurationFile.file_relative_path(title,book))
          puts "Borrado exitosamente la nota '#{title}'  del cuaderno '#{book}"
        end

        def file_exist?(title,book) end

        def operation(title,book)
          self.delete_note(title,book)
        end

        def call(title:, **options)
          self.template(title,**options)
        end
      end

      class Edit < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateFile

        desc 'Edit the content a note'
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'
      
        example [
            'todo                        # Edits a note titled "todo" from the global book',
            '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
            'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
          ]
                
        def file_exist?(title,book)
          if !File.exist?(Configuration::ConfigurationFile.file_relative_path(title, book))
              raise Configuration::FileDirError.new("La nota '#{title}' que desea editar no existe dentro del cuaderno '#{book}'")
          end
        end

        def operation(title,book)
          TTY::Editor.open(Configuration::ConfigurationFile.file_relative_path(title, book))
        end

        def call(title:, **options)
          self.template(title,**options)
        end
      end
 
      class Retitle < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateFile

        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        attr_accessor :old_title

        def initialize
          self.old_title = ''
        end 

        def validation(title,book)
          super(title,book)
          if !Retitle.validate_filename(title)
            raise Configuration::FileDirError.new("El nombre de la nota '#{title}' no es valido")
          end
        end

        def file_exist?(title,book)
          if !File.exist?(Configuration::ConfigurationFile.file_relative_path(self.old_title,book))
            raise Configuration::FileDirError.new("La nota '#{self.old_title}' no existe dentro del cuaderno '#{book}'")
          end
          super(title,book)
        end

        def operation(title,book)
          File.rename(Configuration::ConfigurationFile.file_relative_path(self.old_title,book),Configuration::ConfigurationFile.file_relative_path(title,book))
        end

        def call(old_title:, new_title:, **options)
          self.old_title = old_title
          self.template(new_title,**options)
        end
      end

      class List < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateFile

        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def list_notes_book(book = '')
          puts "'#{book}'"
          Dir.foreach(List.relative_path(book)) do |file|
            if ['.','..'].include?(file)
              return
            end
            puts "   |---> #{file}"
          end
        end
        
        def call(**options)
          book = options[:book]
          global = options[:global]

          if !global and book.nil?
            #Si no pidio global y no hay libro, lista todo
            
            puts "--Todos los cuadernos-- "
            self.list_notes_book
            puts '-' *40
            Dir.foreach(List.relative_path) do |book|
              if ['.','..'].include?(book)
                next
              end
              self.list_notes_book(book)
            end
            return            
          end
          
          if global
            self.list_notes_book("cuaderno global")
          end

          begin
            self.dir_exist?(book = book)
          
            if book == ''
              puts 'El parametro de --books no puede ser vacio'
              return
            end
              
            if !book.nil?
              self.list_notes_book(book)
            end
          rescue => error
            puts error
          end
        end
      end

      class Show < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateFile

        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def validation(title,book)
          if !book.nil? and book == ''
            raise Configuration::FileDirError.new("El parametro --books no puede ser vacio")
          end
        end

        def file_exist?(title,book)
          if !File.exist?(Configuration::ConfigurationFile.file_relative_path(title,book))
            raise Configuration::FileDirError.new("La nota '#{title}' no existe dentro del cuaderno '#{book}'")
          end
        end

        def operation(title,book)
          puts "---Contenido Nota #{title}---"
          File.foreach(Configuration::ConfigurationFile.file_relative_path(title,book)) do |line|
            puts line
          end
        end

        def call(title:, **options)
          self.template(title,**options)
        end
      end
    end
  end
end 
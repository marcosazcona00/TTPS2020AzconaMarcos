module RN
  module Commands
    module Books
      require 'rn/configuration'  
      class Create < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateBook
        
        desc 'Create a book'

        attr_accessor :relative_path

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def dir_exist?(title)
          if Dir.exist?(Create.relative_path(title))
            raise Configuration::FileDirError.new("El cuaderno #{title} ya existe dentro del directorio #{Create.relative_path}")
          end
        end

        def operation(title)
          Dir.mkdir(Configuration::ConfigurationDirectory.relative_path(title))
        end

        def successfull_operation(title)
          puts "El libro #{title} se ha creado exitosamente"
        end

        def call(name:, **kwargs)
          self.template(name,**kwargs)
        end
      end

      class Delete < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateBook

        attr_accessor :relative_path
        
        desc 'Delete a book'
      
        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]
      
        def delete_files(dir_path)
          Dir.foreach(dir_path) do |file|
            if ['.','..'].include?(file)
              next
            end
            File.delete(File.join(dir_path,file))
          end
        end

        def validation(title,global)
          super(title,global)
          if title == 'cuaderno global'
            raise  Configuration::FileDirError.new("El #{title} no puede ser borrado")
          end
        end

        def operation(title)
          if !title.nil?
            dir_path = Delete.relative_path(title)
            self.delete_files(dir_path)
            Dir.delete(dir_path)
          end
        end

        def successfull_operation(title)
          puts "El libro #{title} se ha eliminado exitosamente"
        end

        def call(name: nil, **options)
          global = options[:global]
          if global
            dir_path = Configuration::ConfigurationDirectory.relative_path('cuaderno global')
            self.delete_files(dir_path)  
          end
          self.template(name,**options)
        end      
        private :delete_files
      end

      class List < Dry::CLI::Command
        attr_accessor :relative_path
        
        desc 'List books'

        example [
          '          # Lists every available book'
        ]
        
        def call(*)
          puts '---Listado Cuadernos---'
          Dir.foreach(Configuration::ConfigurationDirectory.relative_path) do |file|
            if ['.','..'].include?(file)
              next
            end
            puts '--> ' + file
          end
          puts '--Fin Listado Cuadernos--'
        end
      end

      class Rename < Dry::CLI::Command
        extend Configuration
        include Configuration::TemplateBook

        attr_accessor :old_name
        
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]
        def dir_exist?(new_title)
          super(self.old_name)
          new_name_path = Rename.relative_path(new_title)
          if Dir.exist?(new_name_path)
            raise Configuration::FileDirError.new("El cuaderno con el nombre #{new_title} ya existe dentro del directorio")
          end
        end

        def operation(new_title)
          File.rename(Rename.relative_path(self.old_name),Rename.relative_path(new_title))
        end

        def successfull_operation(new_title)
          puts "El cuaderno #{self.old_name} a #{new_title} se ha renombrado exitosamente"
        end

        def call(old_name:, new_name:, **)
          begin
            if old_name == 'cuaderno global'
              raise Configuration::FileDirError.new("El cuaderno global no puede ser renombrado")
            end
          rescue => error
            puts error
          else
            self.old_name = old_name
            self.template(new_name)
          end
        end
      end
    end
  end
end
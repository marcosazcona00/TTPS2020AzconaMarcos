
require 'tty-editor'
module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        desc 'Create a note'
        
        
        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoitleires"'
        ]
      
        def call(title:, **options)
          note = NoteModel.new(options[:book],title)
          output = note.create()
          warn output
        end
      end
    
      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          note = NoteModel.new(options[:book],title)
          output = note.delete()
          warn output
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'
      
        example [
            'todo                        # Edits a note titled "todo" from the global book',
            '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
            'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
          ]

        def call(title:, **options)
          note = NoteModel.new(options[:book],title)
          output = note.edit()
          warn output
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
          note = NoteModel.new(options[:book],old_title)
          output = note.retitle(new_title)
          warn output
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
          note = NoteModel.new(options[:book])
          book = options[:book]
          global = options[:global]

          if global
            notes = note.list_global()
            puts "*** Notas cuaderno global ***"
            output = if !notes.empty? then notes else "Sin Notas" end
            puts output
            return
          end

          if !book.nil?
            output, is_valid = note.list_notes_book()
            if !is_valid
              warn output
            else
              puts "*** Notas cuaderno '#{book}' ***"
              output = if !output.empty? then output else "Sin Notas" end
              puts output
            end 
            return
          end

          #Imprimo todas
          notes = note.all_notes()
          
          puts "*******Notas del cajon global********"
          puts note.list_global()
          puts "*************************************\n\n"
          
          notes.each do |book,notes|
            puts "*********#{book}*************"
            output = if !notes.empty? then notes else "Sin notas" end
            puts output
            puts "**************************************\n\n"
          end
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
          note = NoteModel.new(options[:book],title)
          output = note.show()
          warn output
        end
      end

      class Export < Dry::CLI::Command
        desc 'Export a note'

        option :title, type: :string, desc: 'Title of the note to export'
        option :book,  type: :string, desc: 'Book'

        example [
          '                                 # Export all notes',
          '--title note1                    # Export the note "note1" to html from global',
          '--title note2 --book "My Book"   # Export the note "note1" from the book "My Book" to html'
        ]

        def call(**options)
          note = NoteModel.new(options[:book],options[:title])
          output = note.export()
          warn output          
          #Note::NoteModel.export(options)
        end 
      end
    end
  end
end 
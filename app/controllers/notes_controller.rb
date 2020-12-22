class NotesController < ApplicationController
    before_action :authenticate_user!

    def new
        ### Esto es lo que le llega al html
        puts params
        @note = Note.new
        @books = current_user.books
    end

    def create
        title =  params[:note][:title]
        content =  params[:note][:content]

        @note = Note.new(title: title, content: content)
        puts @note.valid?
        puts @note.errors.full_messages
    end
end

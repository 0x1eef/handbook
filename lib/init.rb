require "asciidoctor"
require "cgi"
require "sequel"

require_relative "repository"
require_relative "book"
require_relative "chapter"
require_relative "chapter/section"

DB = Sequel.connect(Book.database)

DB.create_table? :books do 
  primary_key :id
  String :name, null: false
end 

DB.create_table? :chapters do
  primary_key :id
  String :name, null: false
  Integer :book_id, null: false
end

DB.create_table? :sections do
  primary_key :id
  String :text, text: true
  Integer :chapter_id, null: false
end



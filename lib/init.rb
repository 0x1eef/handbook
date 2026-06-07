# frozen_string_literal: true

require "asciidoctor"
require "cgi"
require "roda"
require "sequel"
require "json"

require_relative "router"
require_relative "repository"
require_relative "book"
require_relative "chapter"
require_relative "chapter/section"

DB = Sequel.connect(Book.database)

DB.create_table? :books do
  primary_key :id
  String :name, null: false
  String :path, null: false
end

DB.create_table? :chapters do
  primary_key :id
  String :name, null: false
  String :path, null: false
  Integer :book_id, null: false

  index :book_id
end

DB.create_table? :sections do
  primary_key :id
  String :title, null: false
  String :anchor
  Integer :level, null: false
  Integer :position, null: false
  Integer :source_line
  String :text, text: true
  Integer :chapter_id, null: false

  index :chapter_id
  index :anchor
end

DB.run <<~SQL
  CREATE VIRTUAL TABLE IF NOT EXISTS sections_fts
  USING fts5(
    title,
    text,
    section_id UNINDEXED,
    book_id UNINDEXED,
    chapter_id UNINDEXED
  )
SQL

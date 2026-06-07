# frozen_string_literal: true

class Book
  ##
  # @return [String]
  attr_reader :name

  ##
  # @return [String]
  attr_reader :path

  ##
  # @reutnr [String]
  def self.database
    dir = File.realpath File.join(__dir__, "..", "share", "handbook")
    "sqlite://#{File.join(dir, "database.sqlite3")}"
  end

  ##
  # @return [Book]
  def self.handbook
    repository.books.find { _1.name == "handbook" }
  end

  ##
  # @return [Repository]
  def self.repository
    @repository ||= Repository.new
  end
  private_class_method :repository

  ##
  # @param [Repository] repository
  # @param [String] path
  # @return [Book]
  def initialize(repository, path)
    @repository = repository
    @path = path
    @name ||= File.basename(path)
  end

  ##
  # @return [Array<Chapter>]
  def chapters
    Dir[File.join(path, "*")].filter_map do
      next unless File.directory?(_1)
      Chapter.new(self, _1)
    end
  end
end

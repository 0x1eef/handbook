# frozen_string_literal: true

class Chapter
  ##
  # @return [String]
  attr_reader :name

  ##
  # @return [Book]
  attr_reader :book

  ##
  # @return [String]
  attr_reader :path

  ##
  # @param [Book] book
  # @param [String] path
  # @return [Chapter]
  def initialize(book, path)
    @book = book
    @path = path
    @name = File.basename(path)
    @file = Asciidoctor.load_file File.join(path, "_index.adoc"),
                                  parse: true,
                                  header_footer: false,
                                  doctype: "book"
  end

  ##
  # @return [Chapter::Section]
  def sections(node = @file)
    node.sections.flat_map do
      [_1.extend(Section), *sections(_1)]
    end
  end

  ##
  # @return [String]
  def inspect
    "<#{self.class}:0x#{object_id.to_s(16)} book=#{book.name} name=#{@name}>"
  end
end

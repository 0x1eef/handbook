# frozen_string_literal: true

class Router < Roda
  route do |r|
    r.root do
      response["Content-Type"] = "application/json"
      search(r.params["q"]).to_json
    end
  end

  private

  def search(input)
    query = input.to_s.scan(/[[:alnum:]_:-]+/).join(" ")
    DB.fetch(sql, query).all
  end

  def sql
    <<~SQL
      SELECT
        sections.id,
        sections.title,
        sections.anchor,
        sections.level,
        sections.position,
        sections.source_line,
        sections.text,
        chapters.name AS chapter,
        chapters.path AS chapter_path,
        books.name AS book,
        books.path AS book_path,
        bm25(sections_fts) AS rank
      FROM sections_fts
      JOIN sections ON sections.id = sections_fts.section_id
      JOIN chapters ON chapters.id = sections.chapter_id
      JOIN books ON books.id = chapters.book_id
      WHERE sections_fts MATCH ?
      ORDER BY rank
      LIMIT 10
    SQL
  end
end

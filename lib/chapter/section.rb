class Chapter
  module Section
    ##
    # @return [String]
    def chunk
      [title, *blocks.map { unwrap(_1) }]
        .flatten.compact.map(&:strip)
        .reject(&:empty?).join("\n\n")
    end

    private

    def unwrap(block)
      case block.context
      when :paragraph
        escape(block.content)
      when :listing, :literal
        block.lines.join("\n")
      when :ulist, :olist
        block.items.map { escape(_1.text) }.join("\n")
      when :dlist
        block.items.map do |terms, description|
          term_text = terms.map { escape(_1.text) }.join(", ")
          description_text = description ? escape(description.text) : ""
          [term_text, description_text].reject(&:empty?).join(": ")
        end.join("\n")
      when :table
        block.rows.body.map do |row|
          row.map { escape(_1.text) }.join(" | ")
        end.join("\n")
      end
    end

    def escape(text)
      CGI.unescapeHTML(text.to_s.gsub(/<[^>]*>/, ""))
    end
  end
end
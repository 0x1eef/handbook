# frozen_string_literal: true

class Router < Roda
  route do |r|
    r.on "/" do
      "hello"
    end
  end
end

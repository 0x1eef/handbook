## About

This project represents the 
[FreeBSD documentation repository](https://cgit.freebsd.org/doc) 
as native objects (such as Book, Chapter, and Section) that can 
then be exported to a SQLite3 database for search and retrieval.

## Usage

#### Requirements

A copy of the [FreeBSD documentation repository](https://cgit.freebsd.org/doc) is required. <br>
By default it is expected to be found at `../doc` although you can 
customize the location by setting the environment variable `${DOC_REPO}`.

#### CLI

  $ handbook new-database

#### Library

```ruby
r = Repository.new(locale: "en")
r.books.each do |book|
  print "The book ", book.name, " has #{book.chapters.size} chapters"
end
```

## License

0BSD.
See [LICENSE](./LICENSE)
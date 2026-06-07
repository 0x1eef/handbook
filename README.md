## About

This project represents the 
[FreeBSD documentation repository](https://cgit.freebsd.org/doc) 
as native objects (such as Book, Chapter, and Section) that can 
then be exported to a SQLite3 database for search and retrieval.

## Usage

### Requirements

#### Repository

A copy of the [FreeBSD documentation repository](https://cgit.freebsd.org/doc) is required. <br>
By default it is expected to be found at `../doc` although you can 
customize the location by setting the environment variable `${DOC_REPO}`.

### CLI

#### create-database

Creates a new database in `share/handbook/database.sqlite3`

    $ handbook create-database

#### web

Serves a HTTP API that can query the handbook with FTS

    $ handbook web
    $ fetch 'http://localhost:9292?q=ports'

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
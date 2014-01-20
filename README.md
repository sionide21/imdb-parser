IMDB Parser
===========

[![Build Status](https://travis-ci.org/sionide21/imdb-parser.png?branch=master)](https://travis-ci.org/sionide21/imdb-parser)

A parser for the IMDB actor and actress files.

Parses the `actors.list` and `actresses.list` files from IMDB's [alternate interfaces](http://www.imdb.com/interfaces) page.


## Installation

Add this line to your application's Gemfile:

    gem 'imdb-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install imdb-parser


## Usage

Here is a simple example of how to use the library. Run `rspec` to see a list of the available methods.

```ruby
require 'imdb/parser'

parser = IMDB::Parser::Parser.new(File.open("actors.list" ,'r:ISO-8859-1'))
parser.each do |actor|
    puts actor.name
    puts "=" * actor.name.length
    actor.roles.each do |role|
        puts "  * #{role.title} (#{role.character})"
    end
    puts
end
```

## File encoding

The files provided by IMDB are encoded as `ISO-8859-1`. Make sure you open the files as such or you will get encoding errors.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Fixing broken records

1. Use the utility "next_edgecase" utility to generate a test case for the broken record

 ```sh
ruby -I lib tools/next_edgecase.rb /path/to/actors.list
```

2. Add the resulting case to `spec/role_spec.rb` in the `describe "::parse" do` section.
3. Fix it

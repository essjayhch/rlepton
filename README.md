# Rlepton

Ruby Bindings for the Dropbox Lepton package
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rlepton'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rlepton

## Usage

Lepton is an image compression tool written by dropbox to radically resize JPEG images by manipulating the filters that are used traditionally for JPEG encoding.
This system is a lossless compression that has proven very effective in shrinking images.

Currently they do not offer a shared library to link against, which has discouraged some from implementing an interface for other languages, however there is some advantage for using this.

To compress a file:
    require 'rlepton'
    RLepton::Image.new('/path/to/lepton/binary') do |l|
      l.compress(input_file: '/path/of/image.jpeg', output_file: '/path/of/compressed/file.lep')
    end

To decompress a file:

    RLepton::Image.new('/path/to/lepton/binary') do |l|
      l.depcompress(input_file: '/path/of/image.lep', output_file: '/path/for/uncompressed/file.jpeg')
    end
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rlepton.

# Macaddress

`Macaddress` provides a set of methods to manipulate a MAC Address.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add macaddress
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install macaddress
```

## Usage

```ruby
require 'macaddress'

Macaddress.new("00:00:00:00:00:00")
=> #<Macaddress @macaddress="00:00:00:00:00:00">

Macaddress.new("01:23:45:67:89:ab").to_s
=> "01:23:45:67:89:AB"

# Format normalization
Macaddress.new("00-00-00-00-00-00").to_s
=> "00:00:00:00:00:00"

Macaddress.new("00.00.00.00.00.00").to_s
=> "00:00:00:00:00:00"

# Comparison
Macaddress.new("00.00.00.00.00.00") == Macaddress.new("00.00.00.00.00.00")
=> true

Macaddress.new("00.00.00.00.00.00") == Macaddress.new("00.00.00.00.00.01")
=> false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/interop-tokyo-shownet/macaddress-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

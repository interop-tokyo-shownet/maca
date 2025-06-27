# Maca

maca provides a set of methods to manipulate a MAC Address.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add maca
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install maca
```

## Usage
### Basic

Create a new `Macaddress` object from a MAC Address in various formats.

```ruby
require 'maca'

Macaddress.new("01:23:45:67:89:ab")
=> #<Macaddress:0x000000012073db08 @macaddress="0123456789ab">

Macaddress.new("01:23:45:67:89:ab").to_s
=> "01:23:45:67:89:AB"

Macaddress.new("01:23:45:67:89:ab").to_i
=> 1250999896491
```

### Format String

**Format Normalization**

Normalize various MAC Address notations (hyphenated, dot-separated, raw hex, etc.) into the standard colon-separated format.

```ruby
Macaddress.new("00-00-00-00-00-00").to_s
=> "00:00:00:00:00:00"

Macaddress.new("000000000000").to_s
=> "00:00:00:00:00:00"

Macaddress.new("0000.0000.0000").to_s
=> "00:00:00:00:00:00"

Macaddress.new("000000-000000").to_s
=> "00:00:00:00:00:00"
```

**Format Conversion**

Convert the MAC Address to a custom string format using a specified delimiter and step size.

```ruby
Macaddress.new("00-00-00-00-00-00").to_fs(delimiter: '.', step: 4)
=> "0000.0000.0000"
```

### Comparison

Compare `Macaddress` objects for equality based on their normalized form.

```ruby
Macaddress.new("00:00:00:00:00:00") == Macaddress.new("00:00:00:00:00:00")
=> true

Macaddress.new("00:00:00:00:00:00") == Macaddress.new("00:00:00:00:00:01")
=> false
```

### Address type check

```ruby
Macaddress.new("00:00:00:00:00:00").unicast?
=> true

Macaddress.new("00:00:00:00:00:00").broadcast?
=> false

Macaddress.new("33:33:00:00:00:01").multicast?
=> true

Macaddress.new("02:00:00:00:00:00").locally_administered?
=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/interop-tokyo-shownet/maca.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

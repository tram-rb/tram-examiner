# Tram::Examiner

The gem allows to add a standalone validator to Ruby classes.

This is a part of collection of patterns, extracted from Rails projects - with a special focus on separation and composability of data validations.

[![Gem Version][gem-badger]][gem]
[![Build Status][travis-badger]][travis]
[![Dependency Status][gemnasium-badger]][gemnasium]
[![Code Climate][codeclimate-badger]][codeclimate]

<a href="https://evilmartians.com/">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tram-examiner'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install tram-examiner
```

## Usage

Include the module to the class and define validation rules inside the `schema` block.

```ruby
require "tram-examiner"

class User < Struct.new(:name, :age)
  include Tram::Examiner

  examiner do
    validates :name, presence: true
  end
end
```

Inside the block you should use standard ActiveModel validations. The trick is that instead of including `ActiveModel::Validations` directly, the examiner adds validations to a separate decorator, wrapped around validated object.

It adds a variable `@__examiner__`, which refers to that standalone decorator. Access to validation result is provided via delegators `valid?`, `validate!` and `errors`.

```ruby
user = User.new '', 46

user.valid?          # => false
user.validate!       # Boom with #<<ActiveModel::ValidationError: Validation failed: Name can't be blank>
user.errors.messages # => { name: ["cannot be blank"] }
```

Under the hood:

```ruby
user.is_a? ActiveModel::Validations
# => false

user.instance_variable_get(:@__examiner__).is_a? ActiveModel::Validations
# => true
```

For syntax sugar you can use `let` memoizer helper inside the `examiner` block:

```ruby
class User < Struct.new(:first_name, :last_name, :age)
  include Tram::Examiner

  examiner do
    let(:name) { [first_name, last_name].compact.join(" ") }
    validates :name, presence: true
  end
end

user = User.new '', '', 51
user.errors.messages # => { name: ["cannot be blank"] }
```

Notice the block is evaluated in the scope of standalone validator, not the current class!
That is why neither `let`, nor `validates` are available outside of the block.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[codeclimate-badger]: https://img.shields.io/codeclimate/github/nepalez/tram-examiner.svg?style=flat
[codeclimate]: https://codeclimate.com/github/nepalez/tram-examiner
[gem-badger]: https://img.shields.io/gem/v/tram-examiner.svg?style=flat
[gem]: https://rubygems.org/gems/tram-examiner
[gemnasium-badger]: https://img.shields.io/gemnasium/nepalez/tram-examiner.svg?style=flat
[gemnasium]: https://gemnasium.com/nepalez/tram-examiner
[travis-badger]: https://img.shields.io/travis/nepalez/tram-examiner/master.svg?style=flat
[travis]: https://travis-ci.org/nepalez/tram-examiner

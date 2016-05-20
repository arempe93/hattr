Hattr
=====

[![Build Status](https://travis-ci.org/arempe93/hattr.svg?branch=master)](https://travis-ci.org/arempe93/hattr)
[![Gem Version](https://badge.fury.io/rb/hattr.svg)](https://badge.fury.io/rb/hattr)
[![Coverage Status](https://coveralls.io/repos/github/arempe93/hattr/badge.svg?branch=master)](https://coveralls.io/github/arempe93/hattr?branch=master)

A simple library for interacting with the PSQL `hstore` extension in `ActiveRecord`. Hattr supports coercion of `hstore` attributes based on a simple dsl and will eventually support more advanced features such as Rails validations and more configurable options.

## Basic Usage

Hattr was designed to be simple. All you need is to extend the `Hattr` module and start building your spec.

```ruby
class Television < ActiveRecord::Base
  extend Hattr

  hattr :metadata, :weight, type: Float
  hattr :metadata, :screen_class, type: Integer
end
```

Now when you call `metadata` on your `Television` object, instead of getting an ugly hash back that looks like this:

```ruby
{ "weight" => "35.6", "screen_class" => "55" }
```

You can get back data that matches your specification - like this:

```ruby
{ weight: 35.6, screen_class: 55 }
```

## Advanced Usage

While Hattr was designed to be simple, it was also meant to be flexible to many use cases.

### Attribute Options

#### :type

Sets the type of the attribute which defaults to `String` if not specified. Valid values include `String`, `Integer`, `Fixnum`, `Float`, `Symbol`, `Array`, and `Hash`. Errors may be raised if coercion cannot be completed

```ruby
class Person < ActiveRecord::Base
  extend Hattr

  hattr :metadata, :name    # :type == String
end
```
**Super advanced usage**

For `Array` and `Hash` types, you can specify the types of the keys/values. For example, for an array of numbers and a hash of strings mapped to floats, you can do:

```ruby
class Person < ActiveRecord::Base
  extend Hattr

  hattr :metadata, :array, type: Array[Fixnum]
  hattr :metadata, :hash, type: Hash[String => Float]
end
```

The inner values are subject to inclusion in the list above for normal types.

**NOT ADVANCED ENOUGH**

Since it recursively calls `typecast` on the values of the array and **values** of the hash, you can do some pretty crazy stuff

```ruby
class Person < ActiveRecord::Base
  extend Hattr

  hattr :metadata, :wtf, type: Hash[Symbol => Array[Hash[String => Hash[Symbol => Float]]]]
end
```

Also, in case you're curious, just plain `Hash` and `Array` in the "normal" types list map to `Hash[Symbol => String]` and `Array[String]` respectively behind the scenes.

### Group Options

#### :string_keys

Leaves hash keys as strings instead of symbolizing them. Defaults to `false` if `hattr_group` is not called or `:string_keys` is not specified.

```ruby
class Television < ActiveRecord::Base
  extend Hattr

  hattr_group :metadata, string_keys: true
  hattr :metadata, :weight, type: Float
  hattr :metadata, :screen_class, type: Integer
end
```

### Multiple Attributes

```ruby
class Person < ActiveRecord::Base
  extend Hattr

  hattr :address, :line1, type: String
  hattr :address, :line2, type: String
  hattr :address, :zip, type: Integer

  hattr :metadata, :age, type: Integer
  hattr :metadata, :weight, type: Float
end
```

## Contributing

I would like to add more options to attribute and group dealing with validation, but if you have an idea feel free to open an issue/pull request!

## Installation

#### With RubyGems

To install Hattr with RubyGems:

```
gem install hattr
```

#### With Bundler

To use Hattr with a Bundler managed project:

```
gem 'hattr'
```

## License

Released under the MIT license

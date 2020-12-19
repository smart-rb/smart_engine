# SmartCore::Engine &middot; [![Gem Version](https://badge.fury.io/rb/smart_engine.svg)](https://badge.fury.io/rb/smart_engine) [![Build Status](https://travis-ci.org/smart-rb/smart_engine.svg?branch=master)](https://travis-ci.org/smart-rb/smart_engine)

Generic SmartCore functionality.

## Installation

```ruby
gem 'smart_engine'
```

```shell
bundle install
# --- or ---
gem install smart_engine
```

```ruby
require 'smart_core'
```

---

## Technologies

- [Global set of error types](#global-set-of-error-types)
- [Simple reentrant lock](#simple-reentrant-lock)
- [Atomic thread-safe value container](#atomic-thread-safe-value-container)
- [Any Object Frozener](#any-object-frozener) (classic c-level `frozen?`/`freeze`)
- [Basic Object Refinements](#basic-object-refinements)
- [Inline rescue pipe](#inline-rescue-pipe)

---

### Global set of error types

- `SmartCore::Error` (inherited from `::StandardError`);
- `SmartCore::ArgumentError` (inherited from `::ArgumentError`);
- `SmartCore::FrozenError` (inherited from `::FrozenError`);
- `SmartCore::NameError` (inherited from `::NameError`);
- `SmartCore::TypeError` (inherited from `::TypeError`);

---

### Simple reentrant lock

```ruby
lock = SmartCore::Engine::Lock.new
lock.synchronize { your_code }
```

---

### Atomic thread-safe value container

```ruby
atom = SmartCore::Engine::Atom.new # initial value - nil
atom.value # => nil
# --- or ---
atom = SmartCore::Engine::Atom.new(7) # initial value - 7
atom.value # => 7

# set new value (thread-safely)
atom.swap { |original_value| original_value * 2 }
atom.value # => 14
```

---

### Any Object Frozener

- works with any type of ruby objects (event with `BasicObject`);
- uses classic Ruby C-level `frozen?`/`freeze` functionality;

```ruby
# as a singleton

object = BasicObject.new
SmartCore::Engine::Frozener.frozen?(object) # => false

SmartCore::Engine::Frozener.freeze(object)
SmartCore::Engine::Frozener.frozen?(object) # => true
```

```ruby
# as a mixin

class EmptyObject < BasicObject
  include SmartCore::Engine::Frozener::Mixin
end

object = EmptyObject.new

object.frozen? # => false
object.freeze
object.frozen? # => true
```

---

### Basic Object Refinements

Ruby's `BasicObject` class does not have some fundamental (extremely important) methods:

- `is_a?` / `kind_of?`
- `freeze` / `frozen?`

`SmartCore::Ext::BasicObjectAsObject` refinement solves this problem.

```ruby
# without refinement:
basic_obj = ::BasicObject.new

basic_obj.is_a?(::BasicObject) # raises ::NoMethodError
basic_obj.kind_of?(::BasicObject) # raises ::NoMethodError
basic_obj.freeze # raises ::NoMethodError
basic_obj.frozen? # raises ::NoMethodError
```

```ruby
# with refinement:
using SmartCore::Ext::BasicObjectAsObject

basic_obj = ::BasicObject.new

basic_obj.is_a?(::BasicObject) # => true
basic_obj.kind_of?(::BasicObject)
basic_obj.is_a?(::Integer) # => false
basic_obj.kind_of?(::Integer) # => false

basic_obj.frozen? # => false
basic_obj.freeze # => self
basic_obj.frozen? # => true
```

---

### Inline rescue pipe

- works with an array of proc objects;
- returns the result of the first non-failed proc;
- provides an error interception interface (a block argument);
- fails with the last failed proc exception (if all procs were failed and interceptor was not passed);

#### Return the result of the first non-failed proc

```ruby
SmartCore::Engine::RescueExt.inline_rescue_pipe(
  -> { raise },
  -> { raise },
  -> { 123 },
  -> { 567 },
  -> { raise },
)
# => output: 123
```

#### Fail with the last failed proc exception

```ruby
SmartCore::Engine::RescueExt.inline_rescue_pipe(
  -> { raise(::ArgumentError) },
  -> { raise(::TypeError) },
  -> { raise(::ZeroDivisionError) }
)
# => fails with ZeroDivisionError
```

#### Error interception

```ruby
SmartCore::Engine::RescueExt.inline_rescue_pipe(
  -> { raise(::ArgumentError) },
  -> { raise(::TypeError) },
  -> { raise(::ZeroDivisionError, 'Intercepted exception') }
) do |error|
  error.message
end
# => output: "Intercepted exception"
```

---

## Contributing

- Fork it ( https://github.com/smart-rb/smart_engine )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)

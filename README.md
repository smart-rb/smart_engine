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
- [Simple reenternant lock](#simple-reenternant-lock)
- [Inline rescue pipe](#inline-rescue-pipe)

---

### Global set of error types

- `SmartCore::Error` (inherited from `::StandardError`);
- `SmartCore::ArgumentError` (inherited from `::ArgumentError`);
- `SmartCore::FrozenError` (inherited from `::FrozenError`);
- `SmartCore::NameError` (inherited from `::NameError`);
- `SmartCore::TypeError` (inherited from `::TypeError`);

---

### Simple reenternant lock

```ruby
lock = SmartCore::Engine::Lock.new
lock.synchronize { your_code }
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

### Fail with the last failed proc exception

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

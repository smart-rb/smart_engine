# SmartCore::Engine &middot; <a target="_blank" href="https://github.com/Cado-Labs"><img src="https://github.com/Cado-Labs/cado-labs-logos/raw/main/cado_labs_badge.svg" alt="Supported by Cado Labs" style="max-width: 100%; height: 20px"></a> &middot; [![Gem Version](https://badge.fury.io/rb/smart_engine.svg)](https://badge.fury.io/rb/smart_engine)

Generic SmartCore functionality.

---

<p>
  <a href="https://github.com/Cado-Labs">
    <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_supporting.svg" alt="Supported by Cado Labs" />
  </a>
</p>

---

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
- [Read/Write Lock](#read-write-lock)
- [Cache Storage](#cache-storage)
- [Atomic thread-safe value container](#atomic-thread-safe-value-container)
- [Any Object Frozener](#any-object-frozener) (classic c-level `frozen?`/`freeze`)
- [Basic Object Refinements](#basic-object-refinements) (`SmartCore::Ext::BasicObjectAsObject`)
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

### Read/Write Lock

- non-controlable reader count;
- readers does not lock each other;
- readers waits for writer;
- writer waits for readers;

```ruby
lock = SmartCore::Engine::ReadWriteLock.new

lock.read_sync { ...some-read-op... } # waits for writer
lock.read_sync { ...some-read-op... } # waits for writer
lock.write_sync { ... some-write-op... } # waits for all readers and current writer

# is write_sync lock is owned by current thread?
lock.write_owned? # true or false
```

---

### Cache Storage

- you can use any object as a cache key;
- you can store any object as a cache value;
- you can cache `nil` object too;

- cache `read` has `fetch` semantics:
  - signature: `#read(key, &fallback)`;
  - in the event of cache miss the `&fallback` black will be invoked;
  - the return value of the fallback block will be written to the cache, and that return value will be returned;
- cache `write`:
  - signature: `#write(key, value)`;
  - you can use any object as a cache key;
  - you can store any object as a value;
  - you can write `nil` object too;
- cache clear:
  - signature: `#clear`;

```ruby
cache = SmartCore::Engine::Cache.new

# write and read
cache.write(:amount, 123.456) # => 123.456
cache.read(:amount) # => 123.456

# read non-existing with a fallback
cache.read('name') # => nil
cache.read('name') { 'D@iVeR' } # => 'D@iVeR'
cache.read('name') # => 'D@iVeR'

# store nil object
cache.write(:nil_value, nil) # => nil
cache.read(:nil_value) # => nil
cache.read(:nil_value) { 'rewritten' } # => nil
cache.read(:nil_value) # => nil

# clear cache
cache.clear # => nil
```

```ruby
# aliases:

# write:
cache[:key1] = 'test'

# read:
cache[:key1] # => 'test'

# read with fallback:
cache[:key2] { 'test2' } # => 'test2'
cache[:key2] # => 'test2'
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

Ruby's `BasicObject` class does not have some fundamental (extremely important for instrumenting) methods:

- `is_a?` / `kind_of?`
- `instance_of?`
- `freeze` / `frozen?`
- `hash`
- `nil?`
- `inspect`

`SmartCore::Ext::BasicObjectAsObject` refinement solves this problem (by Ruby's internal API without any manualy-emulated behavior).

```ruby
# without refinement:
basic_obj = ::BasicObject.new

basic_obj.is_a?(::BasicObject) # raises ::NoMethodError
basic_obj.kind_of?(::BasicObject) # raises ::NoMethodError
basic_obj.instance_of?(::BasicObject) # rasies ::NoMethodError
basic_obj.freeze # raises ::NoMethodError
basic_obj.frozen? # raises ::NoMethodError
basic_object.hash # raises ::NoMethodError
basic_object.nil? # raises ::NoMethodError
basic_object.inspect # raises ::NoMethodError
```

```ruby
# with refinement:
using SmartCore::Ext::BasicObjectAsObject

basic_obj = ::BasicObject.new

basic_obj.is_a?(::BasicObject) # => true
basic_obj.kind_of?(::BasicObject) # => true
basic_obj.instance_of?(::BasicObject) # => true
basic_obj.instance_of?(::Object) # => false
basic_obj.is_a?(::Integer) # => false
basic_obj.kind_of?(::Integer) # => false

basic_obj.frozen? # => false
basic_obj.freeze # => self
basic_obj.frozen? # => true

basic_obj.nil? # => false

basic_obj.hash # => 2682859680348634421 (some Integer value)

basic_obj.inspect # => "#<BasicObject:0x00007fe428018628>"
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

## Roadmap

- migrate to Github Actions in CI;
- thread-safety for BasicObject extensions;
- `SmartCore::Engine::Cache`:
  - thread-safety;
  - support for `ttl:` option for `#write` and for fallback block attribute of `#read`;
  - support for key-value-pair iteration;
  - support for `#keys` method;
  - support for `#key?` method;
  - think about some layer of cache object serialization;
- `SmartCore::Engine::ReadWriteLock`:
  - an ability to set a maximum count of readers;

---

## Contributing

- Fork it ( https://github.com/smart-rb/smart_engine )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Supporting

<a href="https://github.com/Cado-Labs">
  <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_logo.png" alt="Supported by Cado Labs" />
</a>

## Authors

[Rustam Ibragimov](https://github.com/0exp)

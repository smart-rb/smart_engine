# Changelog
All notable changes to this project will be documented in this file.

## [0.12.0] - 2021-12-09
### Added
- `using SmartCore::Ext::BasicObjectAsObject` provides native support for:
  - `BasicObject#inspect`;

## [0.11.0] - 2021-01-17
### Added
- Support for **Ruby@3**;

## [0.10.0] - 2020-12-22
### Added
- Support for `#hash` and `#instance_of?` for `SmartCore::Ext::BasicObjectAsObject` refinement;

## [0.9.0] - 2020-12-20
### Added
- New type of utilities: *Extensions* (`SmartCore::Ext`);
- New extension: `SmartCore::Ext::BasicObjectAsObject` refinement:
  - `using SmartCore::Ext::BasicObjectAsObject` provides native support for:
    - `BasicObject#is_a?`;
    - `BasicObject#kind_of?`;
    - `BasicObject#freeze`;
    - `BasicObject#frozen?`;

### Changed
- Updated development dependencies;
- Support for *Ruby@2.4* has ended;

### Fixed
- `SmartCore::Engine::Frozener` can not be used with rubies lower than `@2.7`;

## [0.8.0] - 2020-07-25
### Added
- Any object frozener (`SmartCore::Engine::Frozener`, `SmartCore::Engine::Frozener::Mixin`);

## [0.7.0] - 2020-07-03
### Added
- Atomic threadsafe value container (`SmartCore::Engine::Atom`);

## [0.6.0] - 2020-05-03
### Added
- Inline rescue pipe (`SmartCore::Engine::RescueExt.inline_rescue_pipe`);
- Actualized development dependencies and test environment;

## [0.5.0] - 2020-01-22
### Added
- Global error type `SmartCore::TypeError` inherited from `::TypeError`;

## [0.4.0] - 2020-01-19
### Added
- `SmartCore::Engine::Lock` - simple reentrant-based locking primitive;

## [0.3.0] - 2020-01-17
### Added
- Global error type `SmartCore::NameError` inherited from `::NameError`;

### Changed
- Actualized development dependencies;

### Fixed
- Invalid gem requirement in `bin/console`;

## [0.2.0] - 2020-01-02
### Changed
- `SmartCore::FrozenError` inherits classic `::FrozenError` behaviour for `Ruby >= 2.5.0` and old `::RuntimeError` behaviour for `Ruby < 2.5.0`;

## [0.1.0] - 2020-01-02

- Minimalistic Release :)

# Changelog
All notable changes to this project will be documented in this file.

## [0.6.0] - 2020-05-03

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

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2026-06-24

### Changed

- Updated `database_bridge` dependency to `^1.0.4`
- Switched `DioBridgeTokenManager` import to `database_bridge_core.dart` entry point

## [1.0.3] - 2026-03-11

### Changed

- Replaced `web` package with `universal_html` package

## [1.0.2] - 2026-03-09

### Changed

- Updated package dependencies to their latest versions

## [1.0.1] - 2026-01-08

### Added

- Added `web` package dependency for modern web API support

### Changed

- Updated `DioBridgeTokenManager` to use conditional storage based on platform
- Changed web token storage to use `localStorage` instead of unsupported secure storage
- Updated documentation to clarify security differences between web and native platforms

### Fixed

- Fixed web platform support that was previously declared but non-functional
- Fixed token storage operations to work properly on web platforms using localStorage

## [1.0.0] - 2026-01-08

### Added

- Added `DioBridgeService` class for unified HTTP client interface with Dio
- Added `getMethod()`, `postMethod()`, `putMethod()`, `deleteMethod()`, and `patchMethod()` for full HTTP method support
- Added `DioBridgeTokenManager` for secure encrypted token storage and management
- Added `DioBridgeTokenInterceptor` for automatic Bearer token injection and 401 retry handling
- Added `DioBridgeTokenPair` class for immutable token storage with expiration tracking
- Added `DioBridgeOption` class for request configuration with headers, query parameters, and progress callbacks
- Added `DioBridgeHeader` sealed class for predefined content-type header configurations
- Added `DioBridgeResponseType` sealed class for type-safe response type handling
- Added functional error handling using Either monad from fpdart for all HTTP methods
- Added automatic token refresh capability with configurable callback for seamless 401 handling
- Added progress tracking support for upload and download operations
- Added cross-platform secure storage integration via database_bridge package
- Added extension methods for seamless conversion between Dio and DioBridge types
- Added comprehensive token lifecycle management with authentication state checking

# JRPC

[![Unit Tests](https://github.com/Evref-BL/JRPC/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/Evref-BL/JRPC/actions/workflows/unit-tests.yml)
[![Baseline Groups](https://github.com/Evref-BL/JRPC/actions/workflows/loading-groups.yml/badge.svg)](https://github.com/Evref-BL/JRPC/actions/workflows/loading-groups.yml)
[![Coverage Status](https://coveralls.io/repos/github/Evref-BL/JRPC/badge.svg?branch=main)](https://coveralls.io/github/Evref-BL/JRPC?branch=main)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Pharo](https://img.shields.io/badge/Pharo-6.1%20%E2%86%92%2015-%23aac9ff.svg)](https://pharo.org/download)

Yet another [JSON-RPC 2.0](https://www.jsonrpc.org/specification) implementation for Pharo Smalltalk

- [Origin](#origin)
- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)
- [Contributing](#contributing)

## Origin

JRPC was written by [Julien Delplanque](https://github.com/juliendelplanque),
who designed it against the specification and left behind a test suite that is
the specification's own example section. The history, the design and the
copyright notice are his, and the MIT licence is unchanged.

It was forked from [juliendelplanque/JRPC](https://github.com/juliendelplanque/JRPC),
which has had no change to library code since 2021 and whose CI stops at
Pharo 10. Development continues here.

## Features
- Client and Server support for JSON-RPC 2.0.
- Only depends on Pharo's built-in packages.
- Uses STONJSON to parse JSON internally.
- Transport agnostic (like JSON-RPC 2.0 spec claims).
- Can currently be used over
  - HTTP
  - TCP
- It is easy to add other transport layers.
- Additional `data` when an error occured in the `error` object.

## Installation

To load the project in a Pharo image or declare it as a dependency of your project follow this [instructions](docs/Installation.md).

## Examples

Explore the [documentation](docs/Examples.md)

## Implementation details

See how [message processing](docs/MessageProcessing.md) works in detail.

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)

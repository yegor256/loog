<img src="/logo.svg" width="64px" height="64px"/>

[![EO principles respected here](http://www.elegantobjects.org/badge.svg)](http://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/loog)](http://www.rultor.com/p/yegor256/loog)
[![We recommend RubyMine](http://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![Build Status](https://travis-ci.org/yegor256/loog.svg)](https://travis-ci.org/yegor256/loog)
[![Build status](https://ci.appveyor.com/api/projects/status/4wypa4uq4anp155x?svg=true)](https://ci.appveyor.com/project/yegor256/loog)
[![Gem Version](https://badge.fury.io/rb/loog.svg)](http://badge.fury.io/rb/loog)
[![Maintainability](https://api.codeclimate.com/v1/badges/4346229c7af42b820e84/maintainability)](https://codeclimate.com/github/yegor256/loog/maintainability)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/loog/master/frames)

[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/loog.svg)](https://codecov.io/github/yegor256/loog?branch=master)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/loog)](https://hitsofcode.com/view/github/yegor256/loog)

Loog is an object-oriented logging wrapper around Ruby logger.

First, install it:

```bash
$ gem install loog
```

Then, use it like this:

```ruby
require 'loog'
Loog::VERBOSE.info('Hello, world!')
```

The gem is basically a provider of a few pre-configured loggers, which
you can use for production (`Loog::REGULAR`) or for testing (`Loog::VERBOSE`).
You can also shut it up with `Loog::NULL`.

That's it.

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.


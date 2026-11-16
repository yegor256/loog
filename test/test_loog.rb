# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/loog'

# Loog test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class LoogTest < Minitest::Test
  def test_simple_logging
    Loog::VERBOSE.info('Works?')
  end

  def test_null_logging
    Loog::NULL.info('Should not be visible')
  end

  def test_buffering
    b = Loog::Buffer.new(formatter: Loog::FULL)
    b.debug('Hello, world!')
    b.info('Hello, world!')
    b.warn('Hello, world!')
    b.error('Hello, world!')
    stdout = b.to_s
    assert_includes(stdout, 'Hello')
    assert_includes(stdout, 'DEBUG')
  end

  def test_quiet_buffering
    b = Loog::Buffer.new
    b.info('Hey, друг!')
    b.warn('Bye!')
    b.error('+')
    assert_equal("Hey, друг!\nBye!\n+\n", b.to_s)
  end

  def test_buffer_non_utf
    b = Loog::Buffer.new
    b.debug('привет')
    b.debug([0x41, 0x42, 0xC0].pack('c*'))
    stdout = b.to_s
    assert_includes(stdout, 'AB', stdout)
  end

  def test_handles_invalid_utf_without_exception
    broken = "\xFF\xFE\x12"
    Loog::VERBOSE.info(broken)
    Loog::REGULAR.info(broken)
    Loog::ERRORS.error(broken)
    b = Loog::Buffer.new
    b.info(broken)
    assert_match(/\?+/, b.to_s)
    b = Loog::Buffer.new(formatter: Loog::FULL)
    b.info(broken)
    assert_match(/\?+/, b.to_s)
  end

  def test_compact_keeps_exception_details
    error = KeyError.new('key not found: :foo')
    error.set_backtrace(['lib/loog.rb:42'])
    b = Loog::Buffer.new(formatter: Loog::COMPACT)
    b.error(error)
    out = b.to_s
    assert_includes(out, 'E: key not found: :foo (KeyError)', out)
    assert_includes(out, 'lib/loog.rb:42', out)
  end

  def test_short_keeps_exception_details
    error = KeyError.new('key not found: :foo')
    error.set_backtrace(['lib/loog.rb:42'])
    b = Loog::Buffer.new
    b.error(error)
    out = b.to_s
    assert_includes(out, 'key not found: :foo (KeyError)', out)
    assert_includes(out, 'lib/loog.rb:42', out)
  end

  def test_full_keeps_exception_details
    error = KeyError.new('key not found: :foo')
    error.set_backtrace(['lib/loog.rb:42'])
    b = Loog::Buffer.new(formatter: Loog::FULL)
    b.error(error)
    out = b.to_s
    assert_includes(out, 'key not found: :foo (KeyError)', out)
    assert_includes(out, 'lib/loog.rb:42', out)
  end

  def test_backtrace_of_raised_exception
    b = Loog::Buffer.new
    b.error(the_error)
    out = b.to_s
    assert_includes(out, 'key not found: :foo (KeyError)', out)
    assert_includes(out, 'test_loog.rb', out)
  end

  def test_exception_without_backtrace
    b = Loog::Buffer.new
    b.error(KeyError.new('no backtrace here'))
    assert_includes(b.to_s, 'no backtrace here (KeyError)', b.to_s)
  end

  private

  def the_error
    raise(KeyError, 'key not found: :foo')
  rescue KeyError => e
    e
  end
end

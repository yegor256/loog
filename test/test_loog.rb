# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'tempfile'
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

  def test_null_unknown_prints_nothing
    silently { Loog::NULL.unknown('Should not be visible') }
  end

  def test_null_add_without_severity_prints_nothing
    silently { Loog::NULL.add(nil, 'Should not be visible') }
  end

  def test_null_shovel_prints_nothing
    silently { Loog::NULL << "Should not be visible\n" }
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

  private

  def silently
    file = Tempfile.new('loog')
    stdout = $stdout.dup
    $stdout.reopen(file)
    yield
  ensure
    $stdout.flush
    $stdout.reopen(stdout)
    stdout.close
    assert_empty(File.read(file.path))
    file.close
    file.unlink
  end
end

# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/loog'

# Loog test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
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
    assert(stdout.include?('Hello'))
    assert(stdout.include?('DEBUG'))
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
    msg = [0x41, 0x42, 0xC0].pack('c*')
    b.debug('привет')
    b.debug(msg)
    stdout = b.to_s
    assert(stdout.include?('AB'), stdout)
  end
end

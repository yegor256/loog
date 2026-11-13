# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/loog'
require_relative '../lib/loog/tee'

# Loog::Tee test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class TeeTest < Minitest::Test
  def test_simple_logging
    tee = Loog::Tee.new(Loog::VERBOSE, Loog::REGULAR)
    tee.info('Works?')
    tee.debug('Works?')
    tee.warn('Works?')
    tee.error('Works?')
  end

  def test_block_form_of_logging
    first = Loog::Buffer.new
    second = Loog::Buffer.new
    tee = Loog::Tee.new(first, second)
    tee.debug { 'debug message' }
    tee.info { 'info message' }
    tee.warn { 'warn message' }
    tee.error { 'error message' }
    expected = "debug message\ninfo message\nwarn message\nerror message\n"
    assert_equal(expected, first.to_s)
    assert_equal(expected, second.to_s)
  end
end

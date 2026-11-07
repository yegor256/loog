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
    tee.fatal('Works?')
  end

  def test_fatal_to_all_logs
    one = Loog::Buffer.new
    two = Loog::Buffer.new
    Loog::Tee.new(one, two).fatal('Works?')
    assert_includes(one.to_s, 'Works?')
    assert_includes(two.to_s, 'Works?')
  end

  def test_fatal_query_reflects_any_log
    tee = Loog::Tee.new(Loog::Buffer.new, Loog::Buffer.new(level: Logger::UNKNOWN))
    assert_predicate(tee, :fatal?)
    tee = Loog::Tee.new(Loog::Buffer.new(level: Logger::UNKNOWN), Loog::Buffer.new(level: Logger::UNKNOWN))
    refute_predicate(tee, :fatal?)
  end
end

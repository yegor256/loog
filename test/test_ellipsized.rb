# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'securerandom'
require_relative '../lib/loog'
require_relative '../lib/loog/ellipsized'

# Loog::Ellipsized test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class EllipsizedTest < Minitest::Test
  def test_ellipsizes_info_message
    buf = Loog::Buffer.new
    log = Loog::Ellipsized.new(buf, 10)
    log.info("#{SecureRandom.hex(8)}длинная строка")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_ellipsizes_debug_message
    buf = Loog::Buffer.new
    log = Loog::Ellipsized.new(buf, 10)
    log.debug("#{SecureRandom.hex(8)}こんにちは世界")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_ellipsizes_warn_message
    buf = Loog::Buffer.new
    log = Loog::Ellipsized.new(buf, 10)
    log.warn("#{SecureRandom.hex(8)}предупреждение")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_ellipsizes_error_message
    buf = Loog::Buffer.new
    log = Loog::Ellipsized.new(buf, 10)
    log.error("#{SecureRandom.hex(8)}ошибка тут")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_keeps_short_message_intact
    buf = Loog::Buffer.new
    log = Loog::Ellipsized.new(buf, 100)
    msg = SecureRandom.hex(4)
    log.info(msg)
    assert_includes(buf.to_s, msg, 'short message was modified')
  end

  def test_delegates_debug_query
    log = Loog::Ellipsized.new(Loog::VERBOSE)
    assert_predicate(log, :debug?, 'debug query not delegated')
  end

  def test_delegates_info_query
    log = Loog::Ellipsized.new(Loog::VERBOSE)
    assert_predicate(log, :info?, 'info query not delegated')
  end

  def test_delegates_warn_query
    log = Loog::Ellipsized.new(Loog::VERBOSE)
    assert_predicate(log, :warn?, 'warn query not delegated')
  end

  def test_delegates_error_query
    log = Loog::Ellipsized.new(Loog::VERBOSE)
    assert_predicate(log, :error?, 'error query not delegated')
  end

  def test_squeezes_whitespace_and_newlines
    buf = Loog::Buffer.new
    log = Loog::Ellipsized.new(buf, 1000)
    log.info("привет\n\t  мир   #{SecureRandom.hex(4)}")
    refute_match(/\s{2,}/, buf.to_s, 'whitespace was not squeezed into single spaces')
  end
end

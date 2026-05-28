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
    Loog::Ellipsized.new(buf, 10).info("#{SecureRandom.hex(8)}длинная строка")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_ellipsizes_debug_message
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 10).debug("#{SecureRandom.hex(8)}こんにちは世界")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_ellipsizes_warn_message
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 10).warn("#{SecureRandom.hex(8)}предупреждение")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_ellipsizes_error_message
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 10).error("#{SecureRandom.hex(8)}ошибка тут")
    assert_includes(buf.to_s, '...', 'message was not ellipsized')
  end

  def test_keeps_short_message_intact
    buf = Loog::Buffer.new
    msg = SecureRandom.hex(4)
    Loog::Ellipsized.new(buf, 100).info(msg)
    assert_includes(buf.to_s, msg, 'short message was modified')
  end

  def test_delegates_debug_query
    assert_predicate(Loog::Ellipsized.new(Loog::VERBOSE), :debug?, 'debug query not delegated')
  end

  def test_delegates_info_query
    assert_predicate(Loog::Ellipsized.new(Loog::VERBOSE), :info?, 'info query not delegated')
  end

  def test_delegates_warn_query
    assert_predicate(Loog::Ellipsized.new(Loog::VERBOSE), :warn?, 'warn query not delegated')
  end

  def test_delegates_error_query
    assert_predicate(Loog::Ellipsized.new(Loog::VERBOSE), :error?, 'error query not delegated')
  end

  def test_squeezes_whitespace_and_newlines
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 1000).info("привет\n\t  мир   #{SecureRandom.hex(4)}")
    refute_match(/\s{2,}/, buf.to_s, 'whitespace was not squeezed into single spaces')
  end

  def test_trims_leading_and_trailing_whitespace
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 1000).info("  \n\tсообщение#{SecureRandom.hex(4)}  \t\n")
    refute_match(/^\s|\s$/, buf.to_s.chomp, 'leading or trailing whitespace was not trimmed')
  end
end

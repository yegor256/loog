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

  def test_accepts_exception_for_error
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 100).error(RuntimeError.new('boom'))
    assert_includes(buf.to_s, 'boom', 'exception message was not logged in error')
  end

  def test_accepts_exception_for_info
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 100).info(StandardError.new('err_info'))
    assert_includes(buf.to_s, 'err_info', 'exception was not converted in info')
  end

  def test_accepts_integer_for_info
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 100).info(42)
    assert_includes(buf.to_s, '42', 'integer was not converted to string in info')
  end

  def test_accepts_integer_for_debug
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 100).debug(123)
    assert_includes(buf.to_s, '123', 'integer was not converted to string in debug')
  end

  def test_accepts_symbol_for_warn
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 100).warn(:warning_symbol)
    assert_includes(buf.to_s, 'warning_symbol', 'symbol was not converted to string in warn')
  end

  def test_accepts_symbol_for_debug
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 100).debug(:debug_symbol)
    assert_includes(buf.to_s, 'debug_symbol', 'symbol was not converted to string in debug')
  end

  def test_accepts_complex_object_for_info
    buf = Loog::Buffer.new
    obj = Struct.new(:id, :title).new(1, 'custom_struct')
    Loog::Ellipsized.new(buf, 100).info(obj)
    assert_includes(buf.to_s, obj.to_s, 'complex struct was not logged in info')
  end

  def test_accepts_complex_object_for_debug
    buf = Loog::Buffer.new
    obj = Class.new do
      def to_s
        'complex debug details'
      end
    end.new
    Loog::Ellipsized.new(buf, 100).debug(obj)
    assert_includes(buf.to_s, obj.to_s, 'complex object was not logged in debug')
  end

  def test_accepts_complex_object_for_warn
    buf = Loog::Buffer.new
    obj = Class.new do
      def to_s
        'warning with   multiple   spaces'
      end
    end.new
    Loog::Ellipsized.new(buf, 100).warn(obj)
    assert_includes(buf.to_s, 'warning with multiple spaces', 'complex object was not squeezed in warn')
    refute_nil(obj.to_s)
  end

  def test_accepts_complex_object_for_error
    buf = Loog::Buffer.new
    obj = Class.new do
      def to_s
        'error payload'
      end
    end.new
    Loog::Ellipsized.new(buf, 100).error(obj)
    assert_includes(buf.to_s, obj.to_s, 'complex object was not logged in error')
  end

  def test_ellipsizes_long_exception_in_error
    buf = Loog::Buffer.new
    Loog::Ellipsized.new(buf, 12).error(RuntimeError.new("#{SecureRandom.hex(8)}_extra_long_error"))
    assert_includes(buf.to_s, '...', 'long exception message was not ellipsized')
  end
end

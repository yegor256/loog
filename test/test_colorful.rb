# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'securerandom'
require_relative '../lib/loog'
require_relative '../lib/loog/colorful'

# Loog::Colorful test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class ColorfulTest < Minitest::Test
  def test_colors_debug_message_dark_gray
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).debug(SecureRandom.hex(8))
    assert_includes(buf.to_s, "\e[90m", 'debug message was not colored dark gray')
  end

  def test_colors_error_message_red
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).error(SecureRandom.hex(8))
    assert_includes(buf.to_s, "\e[31m", 'error message was not colored red')
  end

  def test_resets_color_after_debug
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).debug(SecureRandom.hex(8))
    assert_includes(buf.to_s, "\e[0m", 'color was not reset after debug message')
  end

  def test_resets_color_after_error
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).error(SecureRandom.hex(8))
    assert_includes(buf.to_s, "\e[0m", 'color was not reset after error message')
  end

  def test_preserves_debug_message_content
    buf = Loog::Buffer.new
    msg = SecureRandom.hex(8)
    Loog::Colorful.new(buf).debug(msg)
    assert_includes(buf.to_s, msg, 'debug message content was lost')
  end

  def test_preserves_error_message_content
    buf = Loog::Buffer.new
    msg = SecureRandom.hex(8)
    Loog::Colorful.new(buf).error(msg)
    assert_includes(buf.to_s, msg, 'error message content was lost')
  end

  def test_passes_info_without_color
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).info(SecureRandom.hex(8))
    refute_includes(buf.to_s, "\e[", 'info message should not be colored')
  end

  def test_colors_warn_message_orange
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).warn(SecureRandom.hex(8))
    assert_includes(buf.to_s, "\e[33m", 'warn message was not colored orange')
  end

  def test_resets_color_after_warn
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).warn(SecureRandom.hex(8))
    assert_includes(buf.to_s, "\e[0m", 'color was not reset after warn message')
  end

  def test_preserves_warn_message_content
    buf = Loog::Buffer.new
    msg = SecureRandom.hex(8)
    Loog::Colorful.new(buf).warn(msg)
    assert_includes(buf.to_s, msg, 'warn message content was lost')
  end

  def test_delegates_debug_query
    assert_predicate(Loog::Colorful.new(Loog::VERBOSE), :debug?, 'debug query not delegated')
  end

  def test_delegates_info_query
    assert_predicate(Loog::Colorful.new(Loog::VERBOSE), :info?, 'info query not delegated')
  end

  def test_delegates_warn_query
    assert_predicate(Loog::Colorful.new(Loog::VERBOSE), :warn?, 'warn query not delegated')
  end

  def test_delegates_error_query
    assert_predicate(Loog::Colorful.new(Loog::VERBOSE), :error?, 'error query not delegated')
  end

  def test_handles_non_ascii_debug
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).debug("#{SecureRandom.hex(4)}отладка日本語")
    assert_includes(buf.to_s, "\e[90m", 'non-ascii debug was not colored dark gray')
  end

  def test_handles_non_ascii_error
    buf = Loog::Buffer.new
    Loog::Colorful.new(buf).error("#{SecureRandom.hex(4)}ошибка世界")
    assert_includes(buf.to_s, "\e[31m", 'non-ascii error was not colored red')
  end
end

# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative '../loog'

# Log decorator that adds ANSI colors to messages by severity:
#
#  require 'loog'
#  require 'loog/colorful'
#  log = Loog::Colorful.new(Loog::VERBOSE)
#  log.debug('This will be dark gray')
#  log.error('This will be red')
#
# Debug messages are printed in dark gray, warnings in orange,
# and error messages in red. Info messages pass through unchanged.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class Loog::Colorful
  # Makes an instance.
  def initialize(log)
    @log = log
  end

  def debug(msg)
    @log.debug("\e[90m#{msg}\e[0m")
  end

  def debug?
    @log.debug?
  end

  def info(msg)
    @log.info(msg)
  end

  def info?
    @log.info?
  end

  def warn(msg)
    @log.warn("\e[33m#{msg}\e[0m")
  end

  def warn?
    @log.warn?
  end

  def error(msg)
    @log.error("\e[31m#{msg}\e[0m")
  end

  def error?
    @log.error?
  end
end

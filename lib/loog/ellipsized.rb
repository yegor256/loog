# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'ellipsized'
require_relative '../loog'

# Log decorator that makes all lines ellipsized in the middle.
#
#  require 'loog'
#  require 'loog/ellipsized'
#  tee = Loog::Ellipsized.new(Loog::VERBOSE, 10)
#  tee.info('Hello, world!')
#
# Only a part of the message is printed.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class Loog::Ellipsized
  # Makes an instance.
  def initialize(log, width = 100)
    @log = log
    @width = width
  end

  def debug(msg)
    @log.debug(msg.ellipsized(@width))
  end

  def debug?
    @log.debug?
  end

  def info(msg)
    @log.info(msg.ellipsized(@width))
  end

  def info?
    @log.info?
  end

  def warn(msg)
    @log.warn(msg.ellipsized(@width))
  end

  def warn?
    @log.warn?
  end

  def error(msg)
    @log.error(msg.ellipsized(@width))
  end

  def error?
    @log.error?
  end
end

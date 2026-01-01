# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative '../loog'

# A combiner of a few logs together:
#
#  require 'loog'
#  require 'loog/tee'
#  tee = Loog::Tee.new(Loog::VERBOSE, file_logger)
#  tee.info('Hello, world!')
#
# This way you can log to console and to the file at the same time.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2026 Yegor Bugayenko
# License:: MIT
class Loog::Tee
  # Makes an instance.
  def initialize(*logs)
    @logs = logs
  end

  def debug(msg)
    @logs.each { |g| g.debug(msg) }
  end

  def debug?
    @logs.any?(&:debug?)
  end

  def info(msg)
    @logs.each { |g| g.info(msg) }
  end

  def info?
    @logs.any?(&:info?)
  end

  def warn(msg)
    @logs.each { |g| g.warn(msg) }
  end

  def warn?
    @logs.any?(&:warn?)
  end

  def error(msg)
    @logs.each { |g| g.error(msg) }
  end

  def error?
    @logs.any?(&:error?)
  end
end

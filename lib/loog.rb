# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'logger'
require 'time'

# Loog is an object-oriented wrapper around Ruby Logger:
#
#  require 'loog'
#  log = Loog::VERBOSE
#  log.info('Hello, world!')
#
# For more information read
# {README}[https://github.com/yegor256/loog/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
# License:: MIT
module Loog
  # Compact formatter
  COMPACT = proc do |severity, _time, _target, msg|
    prefix = ''
    case severity
    when 'ERROR', 'FATAL'
      prefix = 'E: '
    when 'DEBUG'
      prefix = 'D: '
    end
    "#{prefix}#{msg.to_s.rstrip.gsub("\n", "\n#{' ' * prefix.length}")}\n"
  end

  # Short formatter
  SHORT = proc do |_severity, _time, _target, msg|
    "#{msg.to_s.rstrip}\n"
  end

  # Full formatter
  FULL = proc do |severity, time, _target, msg|
    format(
      "%<time>s %<severity>5s %<msg>s\n",
      time: time.utc.iso8601,
      severity: severity,
      msg: msg.to_s.rstrip
    )
  end

  # No logging at all
  NULL = Logger.new($stdout)
  NULL.level = Logger::UNKNOWN
  NULL.freeze

  # Everything, including debug
  VERBOSE = Logger.new($stdout)
  VERBOSE.level = Logger::DEBUG
  VERBOSE.formatter = COMPACT
  VERBOSE.freeze

  # Info and errors, no debug info
  REGULAR = Logger.new($stdout)
  REGULAR.level = Logger::INFO
  REGULAR.formatter = COMPACT
  REGULAR.freeze

  # Errors only
  ERRORS = Logger.new($stdout)
  ERRORS.level = Logger::ERROR
  ERRORS.formatter = COMPACT
  ERRORS.freeze

  # Accumulator of everything. This class may be used
  # for testing, when it's necessary to accumulate all log
  # messages in one place and then "assert" the presence
  # of certain strings inside them.
  class Buffer < Logger
    # Ctor
    # @param [String] level The level of logging
    # @param [String] formatter The formatter
    def initialize(level: Logger::DEBUG, formatter: Loog::SHORT)
      super(
        $stdout,
        level: level,
        formatter: proc do |severity, time, target, msg|
          @lines.push(formatter.call(severity, time, target, msg))
          ''
        end
      )
      @lines = []
    end

    def to_s
      @lines.map { |s| s.dup.force_encoding('UTF-8') }.join
    end
  end
end

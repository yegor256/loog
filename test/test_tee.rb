# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/loog'
require_relative '../lib/loog/tee'

# Loog::Tee test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Yegor Bugayenko
# License:: MIT
class TeeTest < Minitest::Test
  def test_simple_logging
    tee = Loog::Tee.new(Loog::VERBOSE, Loog::REGULAR)
    tee.info('Works?')
    tee.debug('Works?')
    tee.warn('Works?')
    tee.error('Works?')
  end
end

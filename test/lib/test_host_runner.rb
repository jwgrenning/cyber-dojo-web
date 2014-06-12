#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'HostRunner'

class HostRunnerTests < ActionController::TestCase

  class StubSandbox
    def path
      '.'
    end
  end

  test "command executes within timeout and returns command output" do
    sandbox = StubSandbox.new
    command = 'echo "Hello"'
    max_duration = 2 # seconds
    assert_equal "Hello\n", HostRunner.new.run(paas=nil, sandbox, command, max_duration)
  end

  test "when command times-out output includes unable-to-complete message" do
    sandbox = StubSandbox.new
    command = 'sleep 10000'
    max_duration = 1 # second
    output = HostRunner.new.run(paas=nil, sandbox, command, max_duration)
    assert_match /Unable to complete the tests in 1 seconds/, output
    assert_match /Is there an accidental infinite loop?/, output
    assert_match /Is the server very busy?/, output
    assert_match /Please try again/, output
  end

end

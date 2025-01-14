class TestError < RuntimeError; end

class TestErrorController < ApplicationController
  def create
    raise TestError.new("A test error to exercise our exception handling")
  end
end

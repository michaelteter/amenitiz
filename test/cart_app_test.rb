require "minitest/autorun"
require_relative "../cart_app.rb"

class TestCartApp < Minitest::Test
  def test_launch_app
    assert_equal CartApp.launch_app, 0
  end
end

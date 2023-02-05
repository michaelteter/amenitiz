require "minitest/autorun"
require_relative "../lib/context_service"

class TestContextService < Minitest::Test
  def test_get_context
    ctx = ContextService.get_context
    assert ctx != nil
  end

  def test_update_context
    original_ctx = ContextService.get_context
    foo = { 'a key' => 'a value' }
    returned_context = ContextService.update_context!(foo: foo)
    new_ctx = ContextService.get_context

    assert original_ctx != new_ctx

    assert_equal returned_context, new_ctx
    assert_equal new_ctx[:foo], foo
  end
end

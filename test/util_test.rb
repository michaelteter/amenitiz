require "minitest/autorun"
require_relative "../lib/util.rb"

class TestUtil < Minitest::Test
  def test_substitute_string_template_values
    template = 'Hello {{name}}.  You are number {{n}} in the queue.'
    data = { 'name' => 'Arthur', 'n' => '42' }
    assert_equal(Util.substitute_string_template_values(template: template,
                                                        data:     data),
                 'Hello Arthur.  You are number 42 in the queue.')
  end

  def test_substitute_string_template_values_delim
    template = 'Foo <bar> <baz>'
    data = { 'bar' => 1, 'baz' => 2 }
    assert_equal(Util.substitute_string_template_values(template: template,
                                                        data:     data,
                                                        delim:    '<>'),
                 'Foo 1 2')
  end

  def test_hash_without_key
    orig_h = { a: 1, b: 2 }
    new_h = Util.hash_without_key(orig_h, :b)
    refute_equal orig_h, new_h
    refute_nil orig_h[:b]
    assert_nil new_h[:b]

    empty_h = Util.hash_without_key({}, :foo)
    assert_empty empty_h
  end
end

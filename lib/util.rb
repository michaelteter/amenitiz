module Util
  extend self

  def substitute_string_template_values(template:, data:, delim: '{{}}')
    s = template
    open_delim, close_delim = delim.chars.each_slice(delim.length / 2).map(&:join)
    data.each do |k, v|
      search = "#{open_delim}#{k}#{close_delim}"
      s.gsub!(search, v.to_s)
    end

    s
  end

  def hash_without_key(hash, key)
    hash.reject { |k, _| k == key }
  end

  def formatted_currency(amount, symbol='')
    "#{'%.2f' % amount} #{symbol}".rstrip
  end

  def euro_formatted_currency(amount)
    formatted_currency(amount, '€')
  end
end

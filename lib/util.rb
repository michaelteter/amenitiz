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
end

module CartApp
  extend self

  def launch_app
    puts 'This will become the primary app launcher'
    0
  end
end

CartApp.launch_app if __FILE__ == $PROGRAM_NAME

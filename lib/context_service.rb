module ContextService
  extend self

  def initialize_context
    $context = {}
  end

  def get_context
    initialize_context if $context.nil?
    $context
  end

  def update_context!(args)
    # Intentionally make a new object.  This prevents any code from hanging
    #   on to a fetched context and mutating it, affecting other consumers
    #   of context.
    # In a real world we wouldn't even use globals like this, but it demonstrates
    #   the concept of state management and data (mutation) protection.
    $context = get_context.merge(args)
  end
end

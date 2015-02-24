class CantoMethod
  def initialize params, body
    @params = params
    @body = body
  end

  def call receiver, arguments
    # Create a context of evaluation in which the method will execute
    context = Context.new receiver

    # Assign passed arguments to local variables
    @params.each_with_index do |param, index|
      context.locals[params] = arguments[index]
    end

    # The body is a node (created in the parser)
    @body.eval context
  end
end

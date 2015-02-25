require "parser"
require "runtime"

class Interpreter
  def initialize
    @parser = Parser.new
  end

  def eval code
    @parser.parse(code).eval RootContext
  end
end

class Nodes
  def eval context
    return_value = nil
    nodes.each do |node|
      return_value = node.eval context
    end
    return_value || Constants["nil"] # Last result is return value (or nil if none).
  end
end

class NumberNode
  def eval context
    Constants["Number"].new_with_value value
  end
end

class StringNode
  def eval context
    Constants["String"].new_with_value value
  end
end

class TrueNode
  def eval context
    Constants["true"]
  end
end

class FalseNode
  def eval context
    Constants["false"]
  end
end

class NilNode
  def eval context
    Constants["nil"]
  end
end

class GetConstantNode
  def eval context
    Constants[name]
  end
end

class GetLocalNode
  def eval context
    context.locals[name]
  end
end

class SetConstantNode
  def eval context
    Constants[name] = value.eval context
  end
end

class SetLocalNode
  def eval context
    context.locals[name] = value.eval context
  end
end

class CallNode
  def eval context
    if receiver
      value = receiver.eval context
    else
      value = context.current_self # Default to `self` if no receiver.
    end

    evaluated_arguments = arguments.map { |arg| arg.eval context }
    value.call method, evaluated_arguments
  end
end

class DefNode
  def eval context
    method = CantoMethod.new params, body
    context.current_class.runtime_methods[name] = method
  end
end

class ClassNode
  def eval context
    canto_class = Constants[name] # Check if class is already defined
    unless canto_class
      canto_class = CantoClass.new
      Constants[name] = canto_class
    end
    class_context = Context.new canto_class, canto_class
    body.eval class_context
    canto_class
  end
end

class IfNode
  def eval context
    if condition.eval(context).ruby_value
      body.eval context
    else # If no body is evaluated, we return nil.
      Constants["nil"]
    end
  end
end

class WhileNode
  def eval context
    while condition.eval(context).ruby_value
      body.eval context
    end
    Constants["nil"]
  end
end

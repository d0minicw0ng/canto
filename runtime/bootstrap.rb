Constants                        = {}

Constants["Class"]               = CantoClass.new
Constants["Class"].runtime_class = Constants["Class"]
Constants["Object"]              = CantoClass.new
Constants["Number"]              = CantoClass.new
Constants["String"]              = CantoClass.new

root_self                        = Constants["Object"].new
RootContext                      = Context.new root_self

Constants["TrueClass"]           = CantoClass.new
Constants["FalseClass"]          = CantoClass.new
Constants["NilClass"]            = CantoClass.new

Constants["true"]                = Constants["TrueClass"].new_with_value true
Constants["false"]               = Constants["FalseClass"].new_with_value false
Constants["nil"]                 = Constants["NilClass"].new_with_value nil

Constants["Class"].def :new do |receiver, arguments|
  receiver.new
end

Constants["Object"].def :print do |receiver, arguments|
  puts arguments.first.ruby_value
  Constants["nil"]
end

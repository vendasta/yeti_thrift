# Sample implementation of the SimpleService interface defined in
# thrift/spec.thrift in the root of the spec's directory.

class SimpleServiceHandler
  def mutate(input, add, concat, toggle)
    input.tap do |i|
      i.long += add
      i.int += add
      i.str += concat
      i.t_or_f = toggle
    end
  end
end

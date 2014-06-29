require 'benchmark'

module Bench

  # bench a lambda against a generic array
  # iterate and increment the array size of *10
  # we can shuffle the array for bench against
  # a not preordered array
  def b!(target_proc, options = {}, increment_proc = lambda{|v| v*10})
    size = options[:start] || 100
    iterate = options[:iterate] || 3
    repeat = options[:repeat] || 1_000
    shuffle = options[:shuffle] || false
    Benchmark.bm(60) do |x|
      iterate.times do
        size = increment_proc.call(size)
        arr = (1..size).to_a
        arr.send(:shuffle!) if shuffle
        x.report("Bench array size '#{formatter.call(size)}' with shuffle '#{shuffle}'") { repeat.times {target_proc.call(arr)} }
      end
    end
  end

  def formatter
    lambda{|n| n.to_s.gsub(/(\d)(?=(\d{3})+$)/,'\1.')}
  end


  # bench a set of methods getting the same argument
  # call each method with each value in values
  def bm!(instances = [], methods = [], values = [], repeat = 100)
    Benchmark.bm(60) do |x|
      methods.each do |method|
        instances.each do |instance|
          new_instance = instance.clone
          values.each{|value| x.report("Bench instance #{instance.object_id} #{method} against #{formatter.call(value)}") {repeat.times{new_instance.send(method, value)}}}
        end
      end
    end
  end

  # generate an array
  def a!(num_els = 1_000_000)
    (0..(num_els) - 1).to_a
  end

end


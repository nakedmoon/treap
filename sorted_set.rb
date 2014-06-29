require './bench'

# The domain of the input_data is a set of comparable elements with a = >= <= and <=> operators
# If not the built in sort algorithm does not work because it can't be compare two elements
# With the given initialize method, it seems be a likely condition

class SortedSet

  # initialize the set with the given value(s)
  def initialize(*values)
    # flatten input array so we can use very large array on initialization
    # passing *values as large array raise the argument size limit and a SystemStackError: stack level too deep
    @values = values.flatten.uniq.sort
  end



  # add an element to the set
  # return true if the element was added, false if it was already in the set
  # about time complexity we have
  # - best case: value is the list so we have a O(n) operation
  # - worst case: value is in not in the list so after a O(n) operation we have a O(n*log(n)) operation
  def add(value)
    # The include?(value) iterates through each element of the array till it finds the value in Array
    # So the complexity is O(n) in the worst case (value is not in array)
    # If we are here the @values have n elements already sorted
    # So is more efficient use a binary search for check if value is on array
    # Using binary search we can get:
    # - a O(log(n)) in the worst case (looking for a value already contained the array)
    # - a O(1) in the best case (looking for a value not contained in the array yet)
    # Finally using binary search we can have
    # - if the value is not in array a total time complexity of O(log(n)) + O(n*log(n))
    # - if the value is in array a total time complexity of O(1)
    if include?(value)
      false
    else
      # Complexity of adding value with the << operator is O(1)
      @values << value
      # Ruby use a Quicksort With Median of Three Pivot selection for sort method
      # The complexity of quicksort in the average case is O(n*log(n))
      @values.sort!
      true
    end
  end

  # return true if set contains value, false otherwise
  def include?(value)
    @values.include? value
  end

  # return an array of all the element, sorted
  def values
    @values
  end
end



include Bench

###################################################################
# benchmarking include?(value) method against a value not in array
# include?(value) is a O(n) operation in the worst case
# the worst case is the context on which we can iterate over all elements
# for searching the given element, so the worst case is
# the element is not on the list or the element is at the end of the list
###################################################################
# b!(lambda{|x| x.include?(10_000_000)}, {:iterate => 4})
#                                                                user     system      total        real
# Bench array size '1.000' with shuffle 'false'                  0.070000   0.000000   0.070000 (  0.070017)
# Bench array size '10.000' with shuffle 'false'                 0.700000   0.000000   0.700000 (  0.702881)
# Bench array size '100.000' with shuffle 'false'                7.130000   0.010000   7.140000 (  7.355042)
# Bench array size '1.000.000' with shuffle 'false'             70.980000   0.070000  71.050000 ( 71.996786)
#
# searching for the first element on list is the best case with a O(1) complexity
# b!(lambda{|x| x.include?(1)}, {:iterate => 4})
#                                                                user     system      total        real
# Bench array size '1.000' with shuffle 'false'                  0.000000   0.000000   0.000000 (  0.000330)
# Bench array size '10.000' with shuffle 'false'                 0.000000   0.000000   0.000000 (  0.000336)
# Bench array size '100.000' with shuffle 'false'                0.000000   0.000000   0.000000 (  0.000315)
# Bench array size '1.000.000' with shuffle 'false'              0.010000   0.000000   0.010000 (  0.000361)


###################################################################
# bench binary search (native in ruby 2.x)
# is a O(log(n)) operation
###################################################################
# searching for an element not in array
# b!(lambda{|x| !x.bsearch{|k| k==100_000_000}.nil? }, {:iterate => 5})
#                                                                user     system      total        real
# Bench array size '1.000' with shuffle 'false'                  0.000000   0.000000   0.000000 (  0.001333)
# Bench array size '10.000' with shuffle 'false'                 0.000000   0.000000   0.000000 (  0.001669)
# Bench array size '100.000' with shuffle 'false'                0.010000   0.000000   0.010000 (  0.002159)
# Bench array size '1.000.000' with shuffle 'false'              0.000000   0.000000   0.000000 (  0.002363)
# Bench array size '10.000.000' with shuffle 'false'             0.000000   0.000000   0.000000 (  0.002699)
#
# all searching took about the same time because an element not included
# in array is a O(1) operation with binary search algorithm


# searching for an element in array
# b!(lambda{|x| !x.bsearch{|k| k==10_000_000}.nil? }, {:iterate => 5})
#                                                                user     system      total        real
# Bench array size '1.000' with shuffle 'false'                  0.000000   0.000000   0.000000 (  0.001349)
# Bench array size '10.000' with shuffle 'false'                 0.000000   0.000000   0.000000 (  0.001687)
# Bench array size '100.000' with shuffle 'false'                0.000000   0.000000   0.000000 (  0.001978)
# Bench array size '1.000.000' with shuffle 'false'              0.000000   0.000000   0.000000 (  0.002311)
# Bench array size '10.000.000' with shuffle 'false'             0.000000   0.000000   0.000000 (  0.003691)
#
# the last search took additional time because the element could not be excluded
# and the binary search look for it


###################################################################
# benchmarking ruby native sort array on a sorted array
# Ruby use an optimized quicksort (work well also on presorted arrays)
# is a O(n*log(n)) operation
###################################################################
# b!(lambda{|x| x.sort }, {:shuffle => false, :start => 1024, :iterate => 10}, lambda{|v| v*2})
#                                                               user     system      total        real
# Bench array size '2.048' with shuffle 'false'                  0.020000   0.020000   0.040000 (  0.044393)
# Bench array size '4.096' with shuffle 'false'                  0.050000   0.010000   0.060000 (  0.067425)
# Bench array size '8.192' with shuffle 'false'                  0.100000   0.050000   0.150000 (  0.191856)
# Bench array size '16.384' with shuffle 'false'                 0.190000   0.130000   0.320000 (  0.430337)
# Bench array size '32.768' with shuffle 'false'                 0.410000   0.310000   0.720000 (  0.932992)
# Bench array size '65.536' with shuffle 'false'                 1.090000   0.700000   1.790000 (  2.265972)
# Bench array size '131.072' with shuffle 'false'                2.140000   2.210000   4.350000 (  4.657108)
# Bench array size '262.144' with shuffle 'false'                4.320000   1.530000   5.850000 (  5.913220)
# Bench array size '524.288' with shuffle 'false'                9.190000   4.710000  13.900000 ( 15.884140)
# Bench array size '1.048.576' with shuffle 'false'             18.450000   9.040000  27.490000 ( 31.196466)

# When increasing N from 2048 to 4096, one would expect a 2.18-fold increase
# in the running time of the algorithm, since it is O(n*log(n)) and 4096*log(4096)/2048*log(2048) = 24/11
# there is a 1.5-fold (0.06/0.04)
# When increasing N from 16.384 to 32.768 there is a 2.25-fold
# When increasing N from 262.144 to 524.288 there is a 2.37-fold
# The Benchmark seems to capture the algorithm time complexity

# We can bench also with shuffled array
# b!(lambda{|x| x.sort }, {:shuffle => true, :start => 1024, :iterate => 10}, lambda{|v| v*2})
#                                                               user     system      total        real
# Bench array size '2.048' with shuffle 'true'                   0.310000   0.010000   0.320000 (  0.321917)
# Bench array size '4.096' with shuffle 'true'                   0.690000   0.020000   0.710000 (  0.721480)
# Bench array size '8.192' with shuffle 'true'                   1.490000   0.050000   1.540000 (  1.588352)
# Bench array size '16.384' with shuffle 'true'                  3.190000   0.150000   3.340000 (  3.501859)
# Bench array size '32.768' with shuffle 'true'                  6.770000   0.320000   7.090000 (  7.334382)
# Bench array size '65.536' with shuffle 'true'                 14.800000   0.740000  15.540000 ( 16.072217)
# Bench array size '131.072' with shuffle 'true'                31.410000   2.340000  33.750000 ( 35.085761)
# Bench array size '262.144' with shuffle 'true'                67.380000   1.850000  69.230000 ( 74.099489)
# Bench array size '524.288' with shuffle 'true'               139.840000   5.360000 145.200000 (159.210823)
# Bench array size '1.048.576' with shuffle 'true'             295.130000   9.860000 304.990000 (315.738779)
# This bench result show that given the same array size
# the sort algorithm work better in a pre-ordered array

#########################################################
# Bench SortedSet with default include and add method
# looking for a value not in array and a the edges of array (min, max, ...)
#########################################################
# sorted_set_one = SortedSet.new(a!(1_000_000))
# sorted_set_two = SortedSet.new(a!(10_000_000))
#
# include? method
#
# bm!([sorted_set_one, sorted_set_two], [:include?], [100_000_000, 1, 999_999, 9_999_999])
#
#                                                                    user     system      total        real
# Bench instance 2160192680 include? against 100.000.000         7.150000   0.010000   7.160000 (  7.614920)
# Bench instance 2160192680 include? against 1                   0.000000   0.000000   0.000000 (  0.000040)
# Bench instance 2160192680 include? against 999.999             7.170000   0.010000   7.180000 (  7.349417)
# Bench instance 2160192680 include? against 9.999.999           7.190000   0.020000   7.210000 (  7.391558)
# Bench instance 2234514800 include? against 100.000.000        71.960000   0.170000  72.130000 ( 76.748068)
# Bench instance 2234514800 include? against 1                   0.000000   0.000000   0.000000 (  0.000041)
# Bench instance 2234514800 include? against 999.999             7.270000   0.020000   7.290000 (  7.550437)
# Bench instance 2234514800 include? against 9.999.999          73.050000   0.320000  73.370000 ( 83.185958)
#
# add(value) method
#
# bm!([sorted_set_one, sorted_set_two], [:add], [100_000_000, 1, 999_999, 9_999_999])
#
#                                                                 user     system      total        real
# Bench instance 2160192680 add against 100.000.000              7.180000   0.090000   7.270000 (  8.046442)
# Bench instance 2160192680 add against 1                        0.000000   0.000000   0.000000 (  0.000047)
# Bench instance 2160192680 add against 999.999                  7.140000   0.010000   7.150000 (  7.317063)
# Bench instance 2160192680 add against 9.999.999                7.370000   0.020000   7.390000 (  7.692425)
# Bench instance 2234514800 add against 100.000.000             72.220000   0.250000  72.470000 ( 78.404973)
# Bench instance 2234514800 add against 1                        0.000000   0.000000   0.000000 (  0.000051)
# Bench instance 2234514800 add against 999.999                  7.210000   0.020000   7.230000 (  8.127100)
# Bench instance 2234514800 add against 9.999.999               72.530000   0.240000  72.770000 ( 79.210425)




#########################################################
# Bench SortedSet with optimized include method
#########################################################
# sorted_set_one = SortedSetOptimized.new(a!(1_000_000))
# sorted_set_two = SortedSetOptimized.new(a!(10_000_000))
#
# include? method
#
# bm!([sorted_set_one, sorted_set_two], [:include?], [100_000_000, 1, 999_999, 9_999_999], 10_000)
#                                                                user     system      total        real
# Bench instance 3758922780 include? against 100.000.000         0.020000   0.010000   0.030000 (  0.049142)
# Bench instance 3758922780 include? against 1                   0.020000   0.010000   0.030000 (  0.032621)
# Bench instance 3758922780 include? against 999.999             0.020000   0.000000   0.020000 (  0.033294)
# Bench instance 3758922780 include? against 9.999.999           0.020000   0.000000   0.020000 (  0.023573)
# Bench instance 3831091060 include? against 100.000.000         0.030000   0.010000   0.040000 (  0.056154)
# Bench instance 3831091060 include? against 1                   0.020000   0.010000   0.030000 (  0.044027)
# Bench instance 3831091060 include? against 999.999             0.030000   0.010000   0.040000 (  0.037381)
# Bench instance 3831091060 include? against 9.999.999           0.030000   0.000000   0.030000 (  0.026753)
#
# add(value) method
#
# bm!([sorted_set_one, sorted_set_two], [:add], [100_000_000, 1, 999_999, 9_999_999], 10_000)
#                                                                   user     system      total        real
# Bench instance 3758922780 add against 100.000.000              0.040000   0.070000   0.110000 (  0.182594)
# Bench instance 3758922780 add against 1                        0.030000   0.000000   0.030000 (  0.025680)
# Bench instance 3758922780 add against 999.999                  0.020000   0.000000   0.020000 (  0.029684)
# Bench instance 3758922780 add against 9.999.999                0.200000   0.000000   0.200000 (  0.210516)
# Bench instance 3831091060 add against 100.000.000              0.180000   0.420000   0.600000 (  1.746668)
# Bench instance 3831091060 add against 1                        0.030000   0.000000   0.030000 (  0.039863)
# Bench instance 3831091060 add against 999.999                  0.030000   0.000000   0.030000 (  0.028227)
# Bench instance 3831091060 add against 9.999.999                0.030000   0.000000   0.030000 (  0.034844)





class SortedSetOptimized < SortedSet
  # include with binary search
  # override default instance method
  def include?(value)
    !@values.bsearch{|v| value - v}.nil?
  end
end

# bench ruby algorithms
def bench_algorithms
  b!(lambda{|x| x.include?(10_000_000)}, {:iterate => 4})
  b!(lambda{|x| !x.bsearch{|k| k==100_000_000}.nil? }, {:iterate => 5})
  b!(lambda{|x| !x.bsearch{|k| k==10_000_000}.nil? }, {:iterate => 5})
  b!(lambda{|x| x.sort }, {:shuffle => false, :start => 1024, :iterate => 10}, lambda{|v| v*2})
  b!(lambda{|x| x.sort }, {:shuffle => true, :start => 1024, :iterate => 10}, lambda{|v| v*2})
end

# bench default version
def bench_default_set
  sorted_set_one = SortedSet.new(a!(1_000_000))
  sorted_set_two = SortedSet.new(a!(10_000_000))
  bm!([sorted_set_one, sorted_set_two], [:include?], [100_000_000, 1, 999_999, 9_999_999])
  bm!([sorted_set_one, sorted_set_two], [:add], [100_000_000, 1, 999_999, 9_999_999])
end

# bench patched version
def bench_optimized_set
  sorted_set_one = SortedSetOptimized.new(a!(1_000_000))
  sorted_set_two = SortedSetOptimized.new(a!(10_000_000))
  bm!([sorted_set_one, sorted_set_two], [:include?], [100_000_000, 1, 999_999, 9_999_999], 10_000)
  bm!([sorted_set_one, sorted_set_two], [:add], [100_000_000, 1, 999_999, 9_999_999], 10_000)
end











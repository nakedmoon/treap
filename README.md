# Treap in Ruby
<p>A treap is a binary search tree with a modified way of ordering the nodes.
As usual, each node in the tree has a key value key . In addition, we assign priority , which is a random number chosen independently for each node.
We assume that all priorities are distinct and also that all keys are distinct. 
The nodes of the treap are ordered so that the keys obey the binary-search-tree property and the priorities obey the min-heap order property:</p>

* if V is the left child of U, then key[V] < key[U]
* if V is the right child of U, then key[V] > key[U]
* if V is a child of U, then priority[V] > priority[U]


The time complexity is **log(n)** for insert, find and delete operations.


## Bench SortedSet with optimized include method

```console
sorted_set_one = SortedSetOptimized.new(a!(1_000_000))
sorted_set_two = SortedSetOptimized.new(a!(10_000_000))
bm!([sorted_set_one, sorted_set_two], [:include?], [100_000_000, 1, 999_999, 9_999_999], 10_000)
                                                                user     system      total        real
Bench instance 3758922780 include? against 100.000.000         0.020000   0.010000   0.030000 (  0.049142)
Bench instance 3758922780 include? against 1                   0.020000   0.010000   0.030000 (  0.032621)
Bench instance 3758922780 include? against 999.999             0.020000   0.000000   0.020000 (  0.033294)
Bench instance 3758922780 include? against 9.999.999           0.020000   0.000000   0.020000 (  0.023573)
Bench instance 3831091060 include? against 100.000.000         0.030000   0.010000   0.040000 (  0.056154)
Bench instance 3831091060 include? against 1                   0.020000   0.010000   0.030000 (  0.044027)
Bench instance 3831091060 include? against 999.999             0.030000   0.010000   0.040000 (  0.037381)
Bench instance 3831091060 include? against 9.999.999           0.030000   0.000000   0.030000 (  0.026753)
bm!([sorted_set_one, sorted_set_two], [:add], [100_000_000, 1, 999_999, 9_999_999], 10_000)
                                                                   user     system      total        real
Bench instance 3758922780 add against 100.000.000              0.040000   0.070000   0.110000 (  0.182594)
Bench instance 3758922780 add against 1                        0.030000   0.000000   0.030000 (  0.025680)
Bench instance 3758922780 add against 999.999                  0.020000   0.000000   0.020000 (  0.029684)
Bench instance 3758922780 add against 9.999.999                0.200000   0.000000   0.200000 (  0.210516)
Bench instance 3831091060 add against 100.000.000              0.180000   0.420000   0.600000 (  1.746668)
Bench instance 3831091060 add against 1                        0.030000   0.000000   0.030000 (  0.039863)
Bench instance 3831091060 add against 999.999                  0.030000   0.000000   0.030000 (  0.028227)
Bench instance 3831091060 add against 9.999.999                0.030000   0.000000   0.030000 (  0.034844)
```

## Bench Treap insert, delete and find

```console
treap_one = Treap.new(a!(1_000_000))
treap_two = Treap.new(a!(10_000_000))
bm!([treap_one, treap_two], [:[]], [100_000_000, 1, 999_999, 9_999_999], 10_000)
                                                                user     system      total        real
Bench instance 3122024560 [] against 100.000.000               0.020000   0.000000   0.020000 (  0.024566)
Bench instance 3122024560 [] against 1                         0.020000   0.000000   0.020000 (  0.020856)
Bench instance 3122024560 [] against 999.999                   0.020000   0.000000   0.020000 (  0.022330)
Bench instance 3122024560 [] against 9.999.999                 0.020000   0.000000   0.020000 (  0.022722)
Bench instance 3181222660 [] against 100.000.000               0.030000   0.000000   0.030000 (  0.028747)
Bench instance 3181222660 [] against 1                         0.020000   0.000000   0.020000 (  0.024207)
Bench instance 3181222660 [] against 999.999                   0.050000   0.000000   0.050000 (  0.053224)
Bench instance 3181222660 [] against 9.999.999                 0.030000   0.000000   0.030000 (  0.027066)
bm!([treap_one, treap_two], [:add], [100_000_000, 1, 999_999, 9_999_999], 10_000)
                                                                user     system      total        real
Bench instance 3122024560 add against 100.000.000              0.100000   0.040000   0.140000 (  0.137157)
Bench instance 3122024560 add against 1                        0.080000   0.030000   0.110000 (  0.145373)
Bench instance 3122024560 add against 999.999                  0.090000   0.030000   0.120000 (  0.170627)
Bench instance 3122024560 add against 9.999.999                0.090000   0.030000   0.120000 (  0.159119)
Bench instance 3181222660 add against 100.000.000              0.080000   0.030000   0.110000 (  0.124785)
Bench instance 3181222660 add against 1                        0.110000   0.020000   0.130000 (  0.163633)
Bench instance 3181222660 add against 999.999                  0.150000   0.030000   0.180000 (  0.211673)
Bench instance 3181222660 add against 9.999.999                0.100000   0.030000   0.130000 (  0.144983)
bm!([treap_one, treap_two], [:delete], [100_000_000, 1, 999_999, 9_999_999], 10_000)
                                                              user     system      total        real
Bench instance 3122024560 delete against 100.000.000           0.040000   0.050000   0.090000 (  0.102856)
Bench instance 3122024560 delete against 1                     0.050000   0.060000   0.110000 (  0.197323)
Bench instance 3122024560 delete against 999.999               0.040000   0.050000   0.090000 (  0.098165)
Bench instance 3122024560 delete against 9.999.999             0.050000   0.040000   0.090000 (  0.111373)
Bench instance 3181222660 delete against 100.000.000           0.050000   0.060000   0.110000 (  0.364081)
Bench instance 3181222660 delete against 1                     0.060000   0.070000   0.130000 (  0.223994)
Bench instance 3181222660 delete against 999.999               0.120000   0.130000   0.250000 (  0.421519)
Bench instance 3181222660 delete against 9.999.999             0.050000   0.060000   0.110000 (  0.237587)
```

#### Inserting (100.000.000) in a set contains integer numbers between 0 and 9.999.999 works around 6 time faster on Treap (0.11) compared with SortedSet (0.6)

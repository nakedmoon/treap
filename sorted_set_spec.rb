require 'spec'
require './sorted_set'

describe SortedSetOptimized do
  before(:each) do
    @sorted_set = SortedSetOptimized.new(a!(1000))
  end

  describe "OptimizedSort check include method" do
    it "should include all numbers bertween 0 and 999" do
      (0..999).to_a.shuffle.each{|v| expect(@sorted_set.include?(v)).to be(true)}
    end

    it "should add -1 and return true" do
      expect(@sorted_set.add(-1)).to eql(true)
      expect(@sorted_set.include?(-1)).to be(true)
    end

    it "should add -1 as first element" do
      @sorted_set.add(-1)
      expect(@sorted_set.values.first).to be(-1)
    end

    it "should add 1000 and return true" do
      expect(@sorted_set.add(1000)).to eql(true)
      expect(@sorted_set.include?(1000)).to be(true)
    end

    it "should add 1000 as last element" do
      @sorted_set.add(1000)
      expect(@sorted_set.values.last).to be(1000)
    end

    it "should not add 800 and return false" do
      expect(@sorted_set.include?(800)).to be(true)
      expect(@sorted_set.add(800)).to eql(false)
      expect(@sorted_set.include?(800)).to be(true)
    end


    it "should not add 1000 after i have alredy added" do
      expect(@sorted_set.include?(1000)).to be(false)
      expect(@sorted_set.add(1000)).to eql(true)
      expect(@sorted_set.include?(1000)).to be(true)
      expect(@sorted_set.add(1000)).to eql(false)
    end

  end


end

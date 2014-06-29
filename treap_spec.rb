require 'spec'
require './treap'

describe Treap do

  describe "Treap insert/delete with custom priorities" do

    before(:each) do
      @sequence = [[3,1],[1,6],[0,9],[5,11],[4,14],[9,17],[7,22],[6,42],[8,49],[2,99]]
      @treap = Treap.new
      @sequence.each{|s| @treap.add(s[0],s[1])}

    end

    it "should include all numbers bertween 0 and 999" do
      @sequence.map{|s| s[0]}.each{|v| expect(@treap.include?(v)).to eql(true)}
      expect(@treap.size).to be(@sequence.size)
    end

    it "should add 1.5 and size +1 " do
      expect(@treap.include?(1.5)).to be(false)
      @treap.add(1.5)
      expect(@treap.include?(1.5)).to be(true)
      expect(@treap.size).to be(@sequence.size+1)
    end

    it "should remove 5 and size -1 " do
      expect(@treap.include?(5)).to be(true)
      @treap.delete(5)
      expect(@treap.include?(5)).to be(false)
      expect(@treap.size).to be(@sequence.size-1)
    end

    it "test sequence add 1.5 with priority 4" do
      expect(@treap[3].left.key).to be(1)
      expect(@treap[3].left.left.key).to be(0)
      expect(@treap[3].left.right.key).to be(2)
      expect(@treap[3].right.key).to be(5)
      expect(@treap[3].right.left.key).to be(4)
      expect(@treap[3].right.right.key).to be(9)
      expect(@treap[3].right.right.left.key).to be(7)
      expect(@treap[3].right.right.left.left.key).to be(6)
      expect(@treap[3].right.right.left.right.key).to be(8)
      @treap.add(1.5,4)
      expect(@treap[3].left.key).to be(1.5)
    end



  end

  describe "Treap insert/delete with random priorities" do

    before(:each) do
      @treap = Treap.new(a!(10_000))
    end

    it "should include all numbers bertween 0 and 999" do
      (0..9_999).to_a.shuffle.each{|v| expect(@treap.include?(v)).to eql(true)}
      expect(@treap.size).to be(10_000)
    end

    it "should not add a number in the treap" do
      expect(@treap.include?(1_000)).to be(true)
      @treap.add(1_000)
      expect(@treap.size).to be(10_000)
    end

    it "should remove 1000 and size -1 " do
      expect(@treap.include?(1_000)).to be(true)
      @treap.delete(1_000)
      expect(@treap.include?(1_000)).to be(false)
      expect(@treap.size).to be(9_999)
    end

    it "should add 10000 and size -1 " do
      expect(@treap.include?(10_000)).to be(false)
      @treap.add(10_000)
      expect(@treap.include?(10_000)).to be(true)
      expect(@treap.size).to be(10_001)
    end

    it "testing random priorities against heap rules" do
      @treap.each do |node|
        expect(node.right.priority > node.priority).to eql(true) unless node.right.nil?
        expect(node.left.priority > node.priority).to eql(true) unless node.left.nil?
      end

    end

    it "testing values againt binary search tree rules" do
      @treap.each do |node|
        expect(node.right.key > node.key).to eql(true) unless node.right.nil?
        expect(node.left.key < node.key).to eql(true) unless node.left.nil?
      end

    end



  end


end

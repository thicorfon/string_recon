defmodule StringReconTest do
  use ExUnit.Case

  test "derivate1" do
  	char = :A
  	relations = [{:A,['a']},{:S,[:A,:A]},{:A,[:A,'a']}]
    assert StringRecon.derivate(char, relations) == [['a'],[:A,'a']]
  end

  test "derivate2" do 
  	char = :A
  	relations = [{:B,['a']},{:S,[:A,:A]},{:B,[:A,'a']}]
  	assert StringRecon.derivate(char, relations) == []
  end

  test "derivatedStrings1" do
  	char = :A
  	relations = [{:A,['a']},{:S,[:A,:A]},{:A,[:A,'a']}]
  	size = 4
  	seen = ['b']
  	assert StringRecon.derivatedStrings(StringRecon.derivate(char,relations),['c'],size,seen) == [['b','a','c'],['b',:A,'a','c']]
  end

  test "derivatedStrings2" do
  	char = :A
  	relations = [{:A,['a']},{:S,[:A,:A]},{:A,[:A,'a']}]
  	size = 3
  	seen = ['b']
  	assert StringRecon.derivatedStrings(StringRecon.derivate(char,relations),['c'],size,seen) == [['b','a','c']]
  end

  test "generateStrings1" do
  	relations = [{:A,['a']},{:S,[:A,:A]},{:A,[:A,'a']}]
  	terminals = ['a']
  	nonterminals = [:S,:A]
  	start = :S
  	grammar = [nonterminals,terminals,start,relations]
  	size = 2
  	assert Enum.sort(StringRecon.getDistincts(StringRecon.generateStrings([[start]],grammar,size))) == Enum.sort([[:S],[:A,:A],['a',:A],[:A,'a'],['a','a']])
  end

  test "generateValidStrings1" do
  	relations = [{:A,['a']},{:S,[:A,:A]},{:A,[:A,'a']}]
  	terminals = ['a']
  	nonterminals = [:S,:A]
  	start = :S
  	grammar = [nonterminals,terminals,start,relations]
  	size = 6
  	assert Enum.sort(StringRecon.generateValidStrings([[start]],grammar,size)) == Enum.sort([['a','a'],['a','a','a'],['a','a','a','a'],['a','a','a','a','a'],['a','a','a','a','a','a']])
  end

  test "generateValidStrings2" do
  	relations = [{:S,[:A]},{:S,[:B]},{:S,[:A,:B]},{:A,[:A,'a']},{:A,['a']},{:B,['b']},{:B,['b',:B]}]
  	terminals = ['a','b']
  	nonterminals = [:S,:A,:B]
  	start = :S
  	grammar = [nonterminals,terminals,start,relations]
  	size = 6
  	assert Enum.sort(StringRecon.generateValidStrings([[start]],grammar,size)) == Enum.sort([['a'],
                                                																							['b'],
                                                																							['a','a'],
                                                																							['a','b'],
                                                																							['b','b'],
                                                																							['a','a','a'],
                                                																							['a','a','b'],
                                                																							['a','b','b'],
                                                																							['b','b','b'],
                                                																							['a','a','a','a'],
                                                																							['a','a','a','b'],
                                                																							['a','a','b','b'],
                                                																							['a','b','b','b'],
                                                																							['b','b','b','b'],
                                                																							['a','a','a','a','a'],
                                                																							['a','a','a','a','b'],
                                                																							['a','a','a','b','b'],
                                                																							['a','a','b','b','b'],
                                                																							['a','b','b','b','b'],
                                                																							['b','b','b','b','b'],
                                                																							['a','a','a','a','a','a'],
                                                																							['a','a','a','a','a','b'],
                                                																							['a','a','a','a','b','b'],
                                                																							['a','a','a','b','b','b'],
                                                																							['a','a','b','b','b','b'],
                                                																							['a','b','b','b','b','b'],
                                                																							['b','b','b','b','b','b']
                                                																							])
  end

  test "generateValidStrings3" do
    relations = [{:S,['a',:B]},{:B,['b']},{:B,[:S,'b']}]
    terminals = ['a','b']
    nonterminals = [:S,:B]
    start = :S
    grammar = [nonterminals,terminals,start,relations]
    size = 8
    assert Enum.sort(StringRecon.generateValidStrings([[start]],grammar,size)) == Enum.sort([['a','b'], 
                                                                                               ['a', 'a', 'b','b'], 
                                                                                               ['a', 'a','a','b','b','b'],
                                                                                               ['a','a','a','a','b','b','b','b']])
  end


  test "generateValidStrings4" do
    relations = [{:S,['x',:N]},{:S,['x']},{:N,['y',:M]},{:N,['y']},{:M,['z',:N]},{:M,['z']}]
    terminals = ['x','y','z']
    nonterminals = [:S,:M,:N]
    start = :S
    grammar = [nonterminals,terminals,start,relations]
    size = 8
    assert Enum.sort(StringRecon.generateValidStrings([[start]],grammar,size)) == 
                          Enum.sort([['x'],
                                    ['x', 'y'],
                                    ['x', 'y', 'z'],
                                    ['x', 'y', 'z', 'y'],
                                    ['x', 'y', 'z', 'y', 'z'],
                                    ['x', 'y', 'z', 'y', 'z', 'y'],
                                    ['x', 'y', 'z', 'y', 'z', 'y', 'z'],
                                    ['x', 'y', 'z', 'y', 'z', 'y', 'z', 'y']])
  end

  test "stringRecon1" do

    relations = [{:S,['a',:A,:S]},{:S,['a']},{:A,[:S,'b',:A]},
                 {:A,['b','a']},{:A,[:S,:S]}]
    terminals = ['a','b']
    nonterminals = [:S,:A]
    start = :S
    grammar = [nonterminals,terminals,start,relations]
    assert StringRecon.stringRecon( ['a', 'a', 'b', 'b', 'a', 'a'],grammar) == true
  end


  test "stringRecon2" do

    relations = [{:S,['a',:A,:S]},{:S,['a']},{:A,[:S,'b',:A]},
                 {:A,['b','a']},{:A,[:S,:S]}]
    terminals = ['a','b']
    nonterminals = [:S,:A]
    start = :S
    grammar = [nonterminals,terminals,start,relations]
    assert StringRecon.stringRecon( ['a', 'a', 'b', 'b', 'b', 'a'],grammar) == false
  end  
end

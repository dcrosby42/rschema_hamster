require 'spec_helper'

describe "Basic Hamster usage" do
  # Hash, Vector, List, Set, SortedSet, Deque

  it "has hashes" do
    h1 = Hamster.hash(name: "Dave", number: 38)
    expect(h1).to be
    expect(h1.get(:name)).to eq "Dave"
    expect(h1.get(:number)).to eq 38

    h2 = h1.put(:role, 'dad')
    expect(h2[:name]).to eq "Dave"
    expect(h2[:number]).to eq 38
    expect(h2[:role]).to eq 'dad'

    expect(h1.get(:role)).to be nil
  end

  it "has Vectors" do
    v = Hamster.vector(1,2,3)
    expect(v.length).to eq 3
    expect(v[1]).to eq 2

    v2 = v.set(1,"hi")
    expect(v[1]).to eq 2
    expect(v2[1]).to eq "hi"
  end
end

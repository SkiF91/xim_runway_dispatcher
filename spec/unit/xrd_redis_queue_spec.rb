describe XrdRedis::Queue do
  before(:all) do
    redis = MockRedis.new
    @queue = XrdRedis::Queue.new(redis, '___xrd')
  end

  it "push/pop" do
    @queue.push 1

    expect(@queue.pop).to eq [@queue.queue_name, 1.to_s]
  end

  it "safe_pop" do
    @queue.push 1
    expect(@queue.safe_pop).to eq '1'
    @queue.commit(1)
    expect { @queue.pop }.to raise_error

    @queue.push 2
    expect(@queue.safe_pop).to eq '2'
    @queue.reject(2)
    expect(@queue.pop).to eq [@queue.queue_name, 2.to_s]
  end

  it 'restore' do
    @queue.push 1
    @queue.push 2
    @queue.push 3

    expect(@queue.safe_pop).to eq "1"
    expect(@queue.safe_pop).to eq "2"
    expect(@queue.safe_pop).to eq "3"
    expect { @queue.safe_pop }.to raise_error

    @queue.restore

    expect(@queue.safe_pop).to eq "1"
    expect(@queue.safe_pop).to eq "2"
    expect(@queue.safe_pop).to eq "3"
    expect { @queue.safe_pop }.to raise_error
  end
end
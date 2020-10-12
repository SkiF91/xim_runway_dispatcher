describe CancelService do
  it "call" do
    s = CancelService.new(aircraft)
    allow(s).to receive(:del_from_redis).and_return(true)

    s.call
  end
end
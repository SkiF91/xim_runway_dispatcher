describe XrdBunny do
  it 'Requestor/Replier' do
    req = XrdBunny.requestor('____xrd')
    rep = XrdBunny.replier('____xrd')

    expect(req.class).to eq XrdBunny::RequestReply::Requestor
    expect(rep.class).to eq XrdBunny::RequestReply::Replier


    t_rep = Thread.new {
      rep.subscribe do |payload|
        expect(payload).to eq '1'
        20
      end
    }

    Thread.new { expect(req.publish(1)).to eq '20' }.join(1)
    XrdBunny.stop
    t_rep.exit
  end
end
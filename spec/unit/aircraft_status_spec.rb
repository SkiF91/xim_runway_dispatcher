describe AircraftStatus do
  context "has valid statuses" do
    it "whole" do
      expect(AircraftStatus.humanized_statuses).to eq({ on_take_off: 0, waiting: 1, standby: 2, took_off: 3 })
    end

    it "active" do
      expect(AircraftStatus.active_statuses).to eq [0, 1, 2]
    end

    it "to cancel" do
      expect(AircraftStatus.can_cancel_statuses).to eq [1]
    end
  end

  it "correct constructor" do
    waiting = AircraftStatus.new(1)
    expect(waiting.id).to eq 1
    expect(waiting.name).to eq :waiting

    standby = AircraftStatus.new(:standby)
    expect(standby.id).to eq 2
    expect(standby.name).to eq :standby

    expect { AircraftStatus.new(4) }.to raise_error
    expect { AircraftStatus.new(:unknown) }.to raise_error
  end
end
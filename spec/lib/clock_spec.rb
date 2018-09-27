require_relative '../../lib/clock'

RSpec.describe Clock do
  describe '#degree' do
    it 'returns the smaller degree for given clock hands' do
      expect(Clock.new('12:00 PM').degree).to eql(0)
      expect(Clock.new('12:00 AM').degree).to eql(0)

      expect(Clock.new('3:00 PM').degree).to eql(90)
      expect(Clock.new('3:00 AM').degree).to eql(90)

      expect(Clock.new('6:00 PM').degree).to eql(180)
      expect(Clock.new('6:00 AM').degree).to eql(180)

      expect(Clock.new('9:00 AM').degree).to eql(90)
      expect(Clock.new('9:00 PM').degree).to eql(90)
    end
  end
end
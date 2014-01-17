require 'role'

describe IMDB::Role do
  let(:role) { IMDB::Role.new 'EuroTrip (2004)  [Jenny]  <6>' }
  describe '#title' do
    it "returns the movie title" do
      expect(role.title).to eq("EuroTrip")
    end
  end
  describe '#year' do
    it "returns the year of release" do
      expect(role.year).to eq(2004)
    end
  end
  describe '#character' do
    it "returns the character name" do
      expect(role.character).to eq("Jenny")
    end
  end
  describe '#credit' do
    it "returns the billing position in credits" do
      expect(role.credit).to eq(6)
    end
  end
end

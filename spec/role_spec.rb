require 'role'

describe IMDB::Role do
  let(:role) { IMDB::Role.new 'EuroTrip (2004)  [Jenny]  <6>' }
  it "fails fast when input is malformed" do
    expect { IMDB::Role.new 'bobloblaw attorney at law' }.to raise_exception(IMDB::ParseError, "bobloblaw attorney at law")
  end
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
    it "is nil if not credited" do
      expect(IMDB::Role.new("Night of the Demons (2009)  (uncredited)  [Goth raver]").credit).to be_nil
    end
  end

  describe "::parse" do
    def parse(string)
      IMDB::Role.parse(string)
    end

    it "handles uncredited roles" do
      expect { parse "Night of the Demons (2009)  (uncredited)  [Goth raver]" }.not_to raise_error
    end
    it "handles uncredited tv roles" do
      expect { parse '"Four Star Revue" (1950) {(#1.15)}  [Guest Apache Dancers]' }.not_to raise_error
    end
    it "handles made for TV movies" do
      expect { parse "This American Life Live! (2012) (TV)  [Dancers]" }.not_to raise_error
    end
  end
end

describe IMDB::TVRole do
  let(:role) { IMDB::TVRole.new '"Buffy the Vampire Slayer" (1997) {After Life (#6.3)}  [Dawn Summers]  <4>' }
  it "fails fast when input is malformed" do
    expect { IMDB::TVRole.new 'bobloblaw attorney at law' }.to raise_exception(IMDB::ParseError, "bobloblaw attorney at law")
  end
  describe '#title' do
    it "returns the title of the series" do
      expect(role.title).to eq("Buffy the Vampire Slayer")
    end
  end
  describe '#episode_title' do
    it "returns the title of the episode" do
      expect(role.episode_title).to eq("After Life")
    end
    it "is nil if the title is not provided" do
      expect(IMDB::TVRole.new('"Four Star Revue" (1950) {(#1.15)}  [Guest Apache Dancers]').episode_title).to be_nil
    end
  end
  describe '#season' do
    it "returns the season of the episode" do
      expect(role.season).to eq(6)
    end
  end
  describe '#episode' do
    it "returns the episode number within the season" do
      expect(role.episode).to eq(3)
    end
  end
  describe '#year' do
    it "returns the year the series came out" do
      expect(role.year).to eq(1997)
    end
  end
  describe '#character' do
    it "returns the character name" do
      expect(role.character).to eq("Dawn Summers")
    end
  end
  describe '#credit' do
    it "returns the billing position in credits" do
      expect(role.credit).to eq(4)
    end
  end
end

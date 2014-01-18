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
    it "is nil if no character provided" do
      expect(IMDB::Role.new("El secreto de la Veneno (1997) (V)  <1>").character).to be_nil
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
      expect { parse '"Supernatural" (2005) {99 Problems (#5.17)}  (uncredited)  [Herself]' }.not_to raise_error
    end
    it "handles made for TV movies" do
      expect { parse "This American Life Live! (2012) (TV)  [Dancers]" }.not_to raise_error
    end
    it "handles tv shows by date" do
      expect { parse '"El hormiguero" (2006) {(2011-03-23)}  [Herself]' }.not_to raise_error
    end
    it "handles tv shows wihtout episode information" do
      expect { parse '"La granja tolima" (2004)  [Herself]' }.not_to raise_error
    end
    it "handles tv shows with title but not episode number" do
      expect { parse '"Jenny Jones" (1991) {I Got No Shame, \'Cuz My Chest Gives Me All Game!}  [Herself]' }.not_to raise_error
    end
    it "handles straight to video movies" do
      expect { parse "El secreto de la Veneno (1997) (V)  <1>" }.not_to raise_error
    end
    it "handles ucredited straight to video movies" do
      expect { parse "Fillet of Soul (2001) (V)" }.not_to raise_error
    end
    it "handles weird ass release years" do
      expect { parse "Splitter (2011/I)  [Kidnapped Girl]" }.not_to raise_error
      expect { parse "The Pact (2003/III)  [Brittany Vickson]  <4>" }.not_to raise_error
      expect { parse '"Furor" (1998/I) {(1998-12-19)}  (as Ella Baila Sola)  [Herself]' }.not_to raise_error
    end
    it "handles no character name in tv shows" do
      expect { parse '"Crackhorse Presents" (2012) {High Speed (#1.10)}' }.not_to raise_error
    end
    it "handles alternate character listing" do
      expect { parse '"Casting Qs" (2010) {An Interview with Tracy \'Twinkie\' Byrd (#2.14)}  (as Twinkie Byrd)  [Herself]' }.not_to raise_error
    end
    it "handles arbitrary episode notes" do
      expect { parse '"The Xtra Factor" (2004) {Tulisa\'s Best and Worst (#8.34)}  (archive footage)  [Themselves]' }.not_to raise_error
    end
    it "handles arbitrary movie notes" do
      expect { parse "2nd Annual BET Awards (2002) (TV)  (as 3LW)  [Themselves]" }.not_to raise_error
    end
    it "handles suspended" do
      expect { parse "Rock da Boat (2001) (TV) {{SUSPENDED}}  [Herself]  <1>" }.not_to raise_error
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
    it "is the date of the episode if titles are dates" do
      expect(IMDB::TVRole.new('"El hormiguero" (2006) {(2011-03-23)}  [Herself]').episode_title).to eq("2011-03-23")
    end
    it "is nil if the title is not provided" do
      expect(IMDB::TVRole.new('"Four Star Revue" (1950) {(#1.15)}  [Guest Apache Dancers]').episode_title).to be_nil
    end
  end
  describe '#season' do
    it "returns the season of the episode" do
      expect(role.season).to eq(6)
    end
    it "returns the year of the episode if episode titles are dates" do
      expect(IMDB::TVRole.new('"El hormiguero" (2006) {(2011-03-23)}  [Herself]').season).to eq(2011)
    end
  end
  describe '#episode' do
    it "returns the episode number within the season" do
      expect(role.episode).to eq(3)
    end
    it "returns nil if the episode number is not provied" do
      expect(IMDB::TVRole.new('"El hormiguero" (2006) {(2011-03-23)}  [Herself]').episode).to be_nil
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
    it "returns character name istead 'Themself' credited 'as character'" do
      expect(IMDB::TVRole.new(
        '"Casting Qs" (2010) {An Interview with Tracy \'Twinkie\' Byrd (#2.14)}  (as Twinkie Byrd)  [Herself]'
      ).character).to eq("Twinkie Byrd")
    end
    it "is nil if not credited" do
      expect(IMDB::TVRole.new('"Crackhorse Presents" (2012) {High Speed (#1.10)}').character).to be_nil
    end
  end
  describe '#credit' do
    it "returns the billing position in credits" do
      expect(role.credit).to eq(4)
    end
  end
end

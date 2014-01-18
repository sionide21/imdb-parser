require 'parser'



describe IMDB::Parser, '#parse' do
  let(:contents) { %{
    Trachtenberg, Michelle\tEuroTrip (2004)  [Jenny]  <6>
        "Buffy the Vampire Slayer" (1997) {After Life (#6.3)}  [Dawn Summers]  <4>
  }}

  it "parses actors" do
    parser = IMDB::Parser.new(contents)
    expect(parser.actors.count).to eq(1)
  end
  it "parses roles" do
    parser = IMDB::Parser.new(contents)
    expect(parser.actors.first.roles.count).to eq(2)
  end
  describe "knows role type" do
    let(:roles) { IMDB::Parser.new(contents).actors.first.roles }
    it "parses movies" do
      expect(roles.first.type).to eq(:movie)
    end
    it "parses tv shows" do
      expect(roles.last.type).to eq(:tv)
    end
  end
  context "when passed an IO" do
    it "parses actors" do
      parser = IMDB::Parser.new(StringIO.new(contents.strip))
      expect(parser.actors.count).to eq(1)
    end
  end
end

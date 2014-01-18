require 'imdb/parser'


describe IMDB::Parser::Parser, '#parse' do
  let(:contents) { %{
    Name\t\t\tTitles
    ----\t\t\t------
    Trachtenberg, Michelle\tEuroTrip (2004)  [Jenny]  <6>
        "Buffy the Vampire Slayer" (1997) {After Life (#6.3)}  [Dawn Summers]  <4>
  }}

  it "parses actors" do
    parser = IMDB::Parser::Parser.new(contents)
    expect(parser.actors.count).to eq(1)
  end
  it "parses roles" do
    parser = IMDB::Parser::Parser.new(contents)
    expect(parser.actors.first.roles.count).to eq(2)
  end
  describe "knows role type" do
    let(:roles) { IMDB::Parser::Parser.new(contents).actors.first.roles }
    it "parses movies" do
      expect(roles.first.type).to eq(:movie)
    end
    it "parses tv shows" do
      expect(roles.last.type).to eq(:tv)
    end
  end
  context "when passed an IO" do
    it "parses actors" do
      parser = IMDB::Parser::Parser.new(StringIO.new(contents.strip))
      expect(parser.actors.count).to eq(1)
    end
  end

  context "when input has header or footer" do
    let(:contents) { %{
      blah blah blah
      Somehting....
      ===============================
      Name\t\t\tTitles
      ----\t\t\t------
      Trachtenberg, Michelle\tEuroTrip (2004)  [Jenny]  <6>
          "Buffy the Vampire Slayer" (1997) {After Life (#6.3)}  [Dawn Summers]  <4>

      -----------------------------------------------------------------------------

      Some more stuff
      ===============

      gobbledy gook
    }}
    it "strips it" do
      parser = IMDB::Parser::Parser.new(StringIO.new(contents.strip))
      expect(parser.actors.count).to eq(1)
    end
  end
end

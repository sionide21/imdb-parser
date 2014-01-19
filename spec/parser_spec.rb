require 'imdb/parser'


describe IMDB::Parser::Parser do
  let(:contents) { %{
    Name\t\t\tTitles
    ----\t\t\t------
    Suvari, Mena\tAmerican Pie (1999)  [Heather]  <11>

    Trachtenberg, Michelle\tEuroTrip (2004)  [Jenny]  <6>
        "Buffy the Vampire Slayer" (1997) {After Life (#6.3)}  [Dawn Summers]  <4>
  }}

  it "parses actors" do
    parser = IMDB::Parser::Parser.new(contents)
    expect(parser.actors.count).to eq(2)
  end
  it "can be resumed" do
    parser = IMDB::Parser::Parser.new(contents)
    parser.find { |a| a.name == "Suvari, Mena" }
    expect(parser.to_enum.next.name).to eq("Trachtenberg, Michelle")
  end
  it "parses roles" do
    parser = IMDB::Parser::Parser.new(contents)
    expect(parser.actors.last.roles.count).to eq(2)
  end
  describe "knows role type" do
    let(:roles) { IMDB::Parser::Parser.new(contents).actors.last.roles }
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
      expect(parser.actors.count).to eq(2)
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

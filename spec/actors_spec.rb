require 'actor'

describe IMDB::Actor do
  let(:actor) { 
    IMDB::Actor.new %{Trachtenberg, Michelle\tEuroTrip (2004)  [Jenny]  <6>
      "Buffy the Vampire Slayer" (1997) {After Life (#6.3)}  [Dawn Summers]  <4>} 
  }
  describe '#name' do
    it "returns the actors name" do
      expect(actor.name).to eq("Trachtenberg, Michelle")
    end
  end

  describe '#roles' do
    it "returns a list of roles the actor has been in" do
      expect(actor.roles.count).to eq(2)
    end
  end
end

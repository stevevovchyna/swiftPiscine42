import Foundation

class Deck: NSObject {
    static let allSpades : [Card] = Value.allValues.map({Card(color : Color.spades, value : $0)})
    static let allDiamonds : [Card] = Value.allValues.map({Card(color : Color.diamonds, value : $0)})
    static let allHearts : [Card] = Value.allValues.map({Card(color : Color.hearts, value : $0)})
    static let allClubs : [Card] = Value.allValues.map({Card(color : Color.clubs, value : $0)})
    static let allCards : [Card] = allSpades + allDiamonds + allHearts + allClubs
    var cards : [Card] = allCards
    var disards : [Card] = []
    var outs : [Card] = []
    
    init(deckIsMixed: Bool) {
        self.cards = Deck.allCards
        if deckIsMixed {
            self.cards.shuffleDeck()
        }
    }
    
    func draw() -> Card? {
        var card : Card?
        card = self.cards[0]
        self.outs.append(card!)
        self.cards.remove(at:0)
        return card
    }
    
    func fold(c: Card) {
        var i = 0
        for e in self.outs {
            if c == e {
                self.disards.append(e)
                self.outs.remove(at:i)
            }
            i += 1
        }
    }
    
    override public var description: String {
        return (self.cards.description)
    }
}

extension Array {
    public mutating func shuffleDeck() {
        for i in 0..<self.count {
            let shuffleIndex = Int(arc4random_uniform(UInt32(self.count)))
            if i != shuffleIndex {
                self.swapAt(i, shuffleIndex)
            }
        }
    }
}

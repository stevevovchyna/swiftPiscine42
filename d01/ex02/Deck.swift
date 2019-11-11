import Foundation

class Deck: NSObject {
    static let allSpades : [Card] = Value.allValues.map({Card(color : Color.spades, value : $0)})
    static let allDiamonds : [Card] = Value.allValues.map({Card(color : Color.diamonds, value : $0)})
    static let allHearts : [Card] = Value.allValues.map({Card(color : Color.hearts, value : $0)})
    static let allClubs : [Card] = Value.allValues.map({Card(color : Color.clubs, value : $0)})
    
    static let allCards : [Card] = allSpades + allDiamonds + allHearts + allClubs
}

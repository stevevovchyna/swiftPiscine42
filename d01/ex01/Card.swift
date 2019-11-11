import Foundation

class Card : NSObject {
    var color : Color
    var value : Value
    init(color : Color, value : Value) {
        self.color = color
        self.value = value
    }
    
    override public var description: String {
        return ("This is a card \(self.value) of color \(self.color)")
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Card {
            return(self.color == object.color && self.value == object.value)
        } else {
            return false
        }
    }
}

func ==(uno: Card, dos: Card) -> Bool {
    return (uno.color == dos.color && uno.value == dos.value)
}

let colorsArray : [Color] = Color.allColors
let valuesArray : [Value] = Value.allValues


for color in colorsArray {
    print("\(color) = \(color.rawValue)")
}

for value in valuesArray {
    print("\(value) = \(value.rawValue)")
}

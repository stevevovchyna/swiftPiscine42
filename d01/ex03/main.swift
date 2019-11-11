var deckToShuffle = Deck.allCards

deckToShuffle.shuffleDeck()

print(deckToShuffle)
for card in deckToShuffle {
    print("<----\(card)---->")
}

import Foundation
import UIKit

class FlashCardModel {
    
    private(set) var deck: Deck
    private var currentCardIndex = 0
    private let persistence: DecksPersistence
    
    init(deck: Deck, persistence: DecksPersistence) {
        self.deck = deck
        self.persistence = persistence
    }
    
    func selectCard(atIndex index: Int) {
        currentCardIndex = index
    }
    
    func addCardToDeck(withFront front: String, withBack back: String) {
        let newCard = Card(front: front, back: back, id: UUID())
        deck.cards.append(newCard)
        persistence.createOrUpdate([deck])
    }
    
    func updateCurrentCard(withImageData imageData: Data, withSide side: FlipSide) {
        guard deck.cards.count > 0 else { return }
        
        let encodedImage = imageData.base64EncodedString()
        
        switch side {
        case .front:
            deck.cards[currentCardIndex].frontImage = encodedImage
            persistence.createOrUpdate([deck])
        case .back:
            deck.cards[currentCardIndex].backImage = encodedImage
            persistence.createOrUpdate([deck])
        }
    }
    
    func getCurrentCardImage(withSide side: FlipSide) -> UIImage? {
        
        if side == .front {
            guard let imageData = getCurrentCard()?.frontImage, let dataDecode: Data = Data(base64Encoded: imageData, options:.ignoreUnknownCharacters) else { return nil }
            
            return UIImage(data: dataDecode)
        } else {
            guard let imageData = getCurrentCard()?.backImage, let dataDecode: Data = Data(base64Encoded: imageData, options:.ignoreUnknownCharacters) else { return nil }
            
            return UIImage(data: dataDecode)
        }
    }
    
    func getCurrentCard() -> Card? {
        if deck.cards.count > 0 {
            return deck.cards[currentCardIndex]
        }
        return nil
    }
    
    func moveToNext() {
        if currentCardIndex == deck.cards.count - 1 {
            currentCardIndex = 0
        } else {
            currentCardIndex += 1
        }
    }
    
    func moveToPrevious() {
        if currentCardIndex == 0 {
            currentCardIndex = deck.cards.count - 1
        } else {
            currentCardIndex -= 1
        }
    }
}

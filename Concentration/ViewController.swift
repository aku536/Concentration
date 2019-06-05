//
//  ViewController.swift
//  Concentration
//
//  Created by Кирилл Афонин on 09/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // singleton (?)
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // number of pairs on the deck
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private var cardColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    private var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private var ViewControllerLabel: UIView!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            flipCountLabel.text = "Flips: \(game.flipCount)"
        }
    }
    
    @IBOutlet private weak var pointsLabel: UILabel!
    @IBOutlet private weak var startNewGameButton: UIButton!
    @IBOutlet weak var youWinLabel: UILabel!
    
    // picks the card
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            for index in cardButtons.indices {
                print(game.cards[index])
            }
        }
    }
    
    // updates emoji and background of card and labels
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(game.emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : cardColor
            }
        }
        pointsLabel.text = "Points: \(game.points)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
        if game.theEnd == true {
            youWinLabel.isHidden = false
        }
    }
    
    // resets the game and starts the new one and applies the the theme's colors
    @IBAction private func startNewGame(_ sender: UIButton) {
        game.resetGame()
        updateViewFromModel()
        
        game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
        
        switch game.themeKey {
        case "Halloween":
            cardColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case "Winter":
            cardColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case "Sports":
            cardColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case "Music":
            cardColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case "Vehicles":
            cardColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case "Love":
            cardColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        default:
            cardColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        ViewControllerLabel.backgroundColor = backgroundColor
        flipCountLabel.textColor = cardColor
        pointsLabel.textColor = cardColor
        startNewGameButton.setTitleColor(backgroundColor, for: UIControl.State.normal)
        startNewGameButton.backgroundColor = cardColor
        youWinLabel.isHidden = true
        youWinLabel.textColor = cardColor
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = cardColor
            button.isEnabled = true
        }
    }
}

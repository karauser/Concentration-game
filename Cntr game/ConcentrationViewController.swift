//
//  ConcentrationViewController.swift
//  Cntr game
//
//  Created by Сергей Караваев on 20.04.2021.
//  Copyright © 2022 Karauser. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private var emoji = [Int:String]()
    
    private var emojiChoices = [String]()
    
    private var backGroundColor = UIColor.black
    
    private var cardBackColor = UIColor.orange
    
    var theme: String? {
        didSet {
            emojiChoices2 = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }

    private var emojiChoices2 = "🐵🐷🐙🐶🐰🐸🐥🐯🐮🦀🦋"

   // private var emoji2 = [Card:String]()
    
    
    typealias Theme = (emojiChoices: [String], backGroundColor: UIColor, cardBackColor: UIColor)
    
    private var emojiThemes: [String: Theme] = [
        "Animals": (["🐵","🐷","🐙","🐶","🐰","🐸","🐥","🐯","🐮","🦀","🦋"], #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.9098039216, green: 0.4784313725, blue: 0.6431372549, alpha: 1)),
        "Faces": (["😎","😍","🥶","😈","🤢","😇","😲","😡"], #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        "Sports": (["⚽️","🏀","🏈","🏐","🎾","🎱","🏆","🎲"], #colorLiteral(red: 0.8379629254, green: 0.8381041288, blue: 0.8379442692, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
    ]
    
    private var keys: [String] {
        return Array(emojiThemes.keys)
    }
    
    private var indexTheme = 0 {
        didSet {
            print (indexTheme, keys[indexTheme])
            emoji = [Int:String]()
            titleLable.text = keys[indexTheme]
            (emojiChoices,backGroundColor,cardBackColor) = emojiThemes[keys [indexTheme]] ?? ([],.black,.orange)
            updateAppearance()
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction func newGame(_ sender: UIButton) {
        game.resetGame()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    private func updateAppearance() {
        view.backgroundColor = backGroundColor
        flipCountLabel.textColor = cardBackColor
        scoreLabel.textColor = cardBackColor
        titleLable.textColor = cardBackColor
        newGameButton.setTitleColor(backGroundColor, for: .normal)
        newGameButton.backgroundColor = cardBackColor
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackColor
                }
            }
            scoreLabel.text = "Score: \(game.score)"
            flipCountLabel.text = "Flips: \(game.flipCount)"
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

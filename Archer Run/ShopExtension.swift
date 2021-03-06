//
//  ShopExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/5/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func createShopMenuWindow() {
        getAvailableShopItems()
        
        let window = SKSpriteNode(color: UIColor.flatCoffeeColor(), size: CGSize(width: 550, height: 380))
        gameOverScreen.addChild(window)
        window.zPosition = 50
        
        let alphaBlack = UIColor.black.withAlphaComponent(0.65)
        let bg = SKSpriteNode(color: alphaBlack, size: frame.size)
        window.addChild(bg)
        bg.zPosition = -5
        
        let closeButton = CloseButton()
        window.addChild(closeButton)
        closeButton.position = CGPoint(x: 265, y: 180)
        
        let totalLabel = SKLabelNode(fontNamed: "Menlo Regular")
        totalLabel.fontSize = 28
        totalLabel.text = "Total"
        window.addChild(totalLabel)
        totalLabel.position = CGPoint(x: -10, y: 160)
        
        let totalCoinsLabel = SKLabelNode(fontNamed: "Courier New Bold")
        totalCoinsLabel.fontSize = 32
        window.addChild(totalCoinsLabel)
        totalCoinsLabel.position = CGPoint(x: 0, y: 127.5)
        
        totalCoinsLabel.text = String(userDefaults.integer(forKey: "totalCoins"))
        
        let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "coinGold"), color: UIColor.clear, size: CGSize(width: 30, height: 30))
        window.addChild(coinSprite)
        coinSprite.position = CGPoint(x: 44, y: 172)
        
        let arrowsTexture = SKTexture(imageNamed: "arrowsButton")
        let charactersTexture = SKTexture(imageNamed: "charactersButton")
        let miscTexture = SKTexture(imageNamed: "miscButton")
        
        let arrowsButton = MSButtonNode(texture: arrowsTexture, color: UIColor.clear, size: arrowsTexture.size())
        window.addChild(arrowsButton)
        arrowsButton.position = CGPoint(x: 0, y: 70)
        
        arrowsButton.selectedHandler = {
            //Create arrows shop window
            self.createItemsWindowForCategory("arrows", menuWindowCoinLabel: totalCoinsLabel)
        }
        
        let charactersButton = MSButtonNode(texture: charactersTexture, color: UIColor.clear, size: charactersTexture.size())
        window.addChild(charactersButton)
        charactersButton.position = CGPoint(x: 0, y: -35)
        
        charactersButton.selectedHandler = {
            self.createItemsWindowForCategory("characters", menuWindowCoinLabel: totalCoinsLabel)
        }
        
        let miscButton = MSButtonNode(texture: miscTexture, color: UIColor.clear, size: miscTexture.size())
        window.addChild(miscButton)
        miscButton.position = CGPoint(x: 0, y: -140)
    }
    
    func createItemsWindowForCategory(_ category: String, menuWindowCoinLabel: SKLabelNode) {
        shopIndex = 0
        
        var itemData = [String: Bool]()
        var defaultsKey: String!
        var itemKeys = [String]()
        var spriteSize: CGSize = CGSize(width: 306, height: 45)
        var totalCoinCount = userDefaults.integer(forKey: "totalCoins")
        
        if category == "arrows" {
            //get arrows data
            itemData = availableArrows
            defaultsKey = "availableArrows"
        }
        else if category == "characters" {
            //get characters data
            itemData = availableCharacters
            defaultsKey = "availableCharacters"
        }
        else if category == "misc" {
            //get misc data
            defaultsKey = "availableMisc"
        }
        
        var priceDict = [String: Int]()
        for (key, _) in itemData {
            priceDict[key] = ShopItem.getPrice(key)
        }
        
        itemKeys = priceDict.keysSortedByValue(<)
        
        var item = ShopItem(key: itemKeys[shopIndex], isBought: itemData[itemKeys[shopIndex]]!)
        
        if let size = item.size {
            spriteSize = size
        }
        
        let window = SKSpriteNode(color: UIColor.flatCoffeeColor(), size: CGSize(width: 550, height: 380))
        gameOverScreen.addChild(window)
        window.zPosition = 55
        
        let closeButton = CloseButton()
        window.addChild(closeButton)
        closeButton.position = CGPoint(x: 265, y: 180)
        
        let itemHolder = SKSpriteNode(texture: SKTexture(imageNamed: "item-holder"), color: UIColor.clear, size: CGSize(width: 414, height: 175))
        window.addChild(itemHolder)
        itemHolder.position = CGPoint(x: 0, y: 70)
        
        let itemSprite = SKSpriteNode(texture: item.texture, color: UIColor.clear, size: spriteSize)
        itemHolder.addChild(itemSprite)
        itemSprite.position = CGPoint(x: 0, y: 20)
        itemSprite.zPosition = 5
        
        let priceLabel = SKLabelNode(fontNamed: "Courier New Bold")
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.fontSize = 28
        priceLabel.fontColor = UIColor.flatYellowColor()
        itemHolder.addChild(priceLabel)
        priceLabel.position = CGPoint(x: -155, y: -70)
        priceLabel.zPosition = 5
        
        let itemNameLabel = SKLabelNode(fontNamed: "Menlo Regular")
        itemNameLabel.fontSize = 36
        itemNameLabel.text = item.name
        window.addChild(itemNameLabel)
        itemNameLabel.position = CGPoint(x: 0, y: -65)
        
        let availableCoinsLabel = SKLabelNode(fontNamed: "Courier New Bold")
        availableCoinsLabel.horizontalAlignmentMode = .left
        availableCoinsLabel.fontSize = 32
        availableCoinsLabel.text = String(totalCoinCount)
        window.addChild(availableCoinsLabel)
        availableCoinsLabel.position = CGPoint(x: -242, y: 161)
        
        let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "coinGold"), color: UIColor.clear, size: CGSize(width: 30, height: 30))
        window.addChild(coinSprite)
        coinSprite.position = CGPoint(x: -250, y: 172.5)
        
        let prevButton = MSButtonNode(texture: SKTexture(imageNamed: "prevButton"), color: UIColor.clear, size: CGSize(width: 103, height: 103))
        window.addChild(prevButton)
        prevButton.position = CGPoint(x: -140, y: -140)
        
        let nextButton = MSButtonNode(texture: SKTexture(imageNamed: "nextButton"), color: UIColor.clear, size: CGSize(width: 103, height: 103))
        window.addChild(nextButton)
        nextButton.position = CGPoint(x: 140, y: -140)
        
        let manageButton = MSButtonNode(texture: SKTexture(imageNamed: "buyButton"), color: UIColor.clear, size: CGSize(width: 207, height: 52))
        window.addChild(manageButton)
        manageButton.position = CGPoint(x: 0, y: -140)
        
        let selectHandler: () -> Void = {
            self.setEquippedTypeForCategory(category, rawValue: item.key)
            manageButton.texture = SKTexture(imageNamed: "equippedPlaceholder")
            manageButton.state = .disabled
        }
        
        let buyHandler: () -> Void = {
            if totalCoinCount > item.price {
                totalCoinCount -= item.price
                
                itemData[item.key] = true
                item.isBought = true
                
                self.userDefaults.set(totalCoinCount, forKey: "totalCoins")
                self.userDefaults.set(itemData, forKey: defaultsKey)
                self.userDefaults.synchronize()
                
                let totalCoinString = String(totalCoinCount)
                availableCoinsLabel.text = totalCoinString
                self.totalCoinCountLabel.text = totalCoinString
                menuWindowCoinLabel.text = totalCoinString
                
                priceLabel.text = ""
                manageButton.texture = SKTexture(imageNamed: "selectButton")
                
                manageButton.selectedHandler = selectHandler
            }
        }
        
        if item.isBought {
            priceLabel.text = ""
            if isEquipped(category, rawValue: item.key) {
                manageButton.texture = SKTexture(imageNamed: "equippedPlaceholder")
                manageButton.state = .disabled
            }
            else {
                manageButton.texture = SKTexture(imageNamed: "selectButton")
                manageButton.selectedHandler = selectHandler
            }
        }
        else {
            priceLabel.text = String(item.price)
            manageButton.texture = SKTexture(imageNamed: "buyButton")
            manageButton.selectedHandler = buyHandler
        }
        
        nextButton.selectedHandler = {
            item = self.updateStoreItem(true, itemKeys: itemKeys, itemData: itemData, itemNameLabel: itemNameLabel, itemSprite: itemSprite, priceLabel: priceLabel, manageButton: manageButton, category: category, selectHandler: selectHandler, buyHandler: buyHandler)
        }
        prevButton.selectedHandler = {
            item = self.updateStoreItem(false, itemKeys: itemKeys, itemData: itemData, itemNameLabel: itemNameLabel, itemSprite: itemSprite, priceLabel: priceLabel, manageButton: manageButton, category: category, selectHandler: selectHandler, buyHandler: buyHandler)
        }
    }
    
    func updateStoreItem(_ next: Bool, itemKeys: [String], itemData: [String: Bool], itemNameLabel: SKLabelNode, itemSprite: SKSpriteNode, priceLabel: SKLabelNode, manageButton: MSButtonNode, category: String, selectHandler: @escaping () -> Void, buyHandler: @escaping () -> Void) -> ShopItem {
        if next {
            self.shopIndex += 1
            if self.shopIndex >= itemKeys.count {
                self.shopIndex = 0
            }
        }
        else {
            self.shopIndex -= 1
            if self.shopIndex < 0 {
                self.shopIndex = itemKeys.count - 1
            }
        }
        
        let item = ShopItem(key: itemKeys[self.shopIndex], isBought: itemData[itemKeys[self.shopIndex]]!)
        
        itemNameLabel.text = item.name
        itemSprite.texture = item.texture
        
        if let size = item.size {
            itemSprite.size = size
        }
        
        if item.isBought {
            priceLabel.text = ""
            if isEquipped(category, rawValue: item.key) {
                manageButton.texture = SKTexture(imageNamed: "equippedPlaceholder")
                manageButton.state = .disabled
            }
            else {
                manageButton.texture = SKTexture(imageNamed: "selectButton")
                manageButton.selectedHandler = selectHandler
                manageButton.state = .active
            }
        }
        else {
            priceLabel.text = String(item.price)
            manageButton.texture = SKTexture(imageNamed: "buyButton")
            manageButton.selectedHandler = buyHandler
            manageButton.state = .active
        }
        
        return item
    }
    
    func getAvailableShopItems() {
        if let dict = userDefaults.dictionary(forKey: "availableArrows") {
            availableArrows = dict as! [String:Bool]
        }
        else {
            availableArrows["regular"] = true
            availableArrows["ice"] = false
            availableArrows["fire"] = false
            availableArrows["explosive"] = false
            userDefaults.set(availableArrows, forKey: "availableArrows")
            userDefaults.synchronize()
        }
        
        if let dict = userDefaults.dictionary(forKey: "availableCharacters") {
            availableCharacters = dict as! [String: Bool]
        }
        else {
            availableCharacters["archer"] = true
            availableCharacters["angel"] = false
            userDefaults.set(availableCharacters, forKey: "availableCharacters")
            userDefaults.synchronize()
        }
    }
    
    func setEquippedTypeForCategory(_ category: String, rawValue: String) {
        let key = getRawKeyForCategory(category)
        
        userDefaults.set(rawValue, forKey: key)
        userDefaults.synchronize()
    }
    
    func isEquipped(_ category: String, rawValue: String) -> Bool {
        let key = getRawKeyForCategory(category)
        
        let equippedRaw = userDefaults.string(forKey: key)
        
        return equippedRaw == rawValue
    }
    
    func getRawKeyForCategory(_ category: String) -> String {
        var key: String = ""
        
        if category == "arrows" {
            key = "arrowRawValue"
        }
        else if category == "characters" {
            key = "archerRawValue"
        }
        
        return key
    }
}

//
//  Item.swift
//  Tastii
//
//  Created by Terry Bu on 12/11/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import Foundation

enum MenuItemType {
    case Special, MenuItem
}

class Item {
    var name: String
    var description: String?
    var price: String?
    var imageName: String?
    var id: String?
    var matchPercent: Int?
    var itemType: MenuItemType?
    
    var isMatchForCurrentUser = false
    var idStringOfMatchObject: String? //this is in case an item gets marked off as a match, to save the string somewhere that we can retrieve later 
    var numberOfMatchedUsers = 0
    var matchedUsersToShow: [User]? 
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, description: String, price: String) {
        self.name = name
        self.description = description
        self.price = price
    }
    
    init(name: String, imageName: String?) {
        self.name = name
        self.imageName = imageName
    }
    
}
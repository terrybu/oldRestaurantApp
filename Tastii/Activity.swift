//
//  Activity.swift
//  Tastii
//
//  Created by Terry Bu on 12/11/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import Foundation

enum ActivityType{
    case TastiingRedeem
    case TastiingShare
    case TastiingLoved
    case TasteMatchAdd
}

class Activity {
    
    var type: ActivityType
    var user: User
    var item: Item
    var dateCreated: NSDate

    init(type: ActivityType, user: User, item: Item, created: NSDate) {
        self.type = type
        self.dateCreated = created
        self.user = user
        self.item = item
    }
    
    
}
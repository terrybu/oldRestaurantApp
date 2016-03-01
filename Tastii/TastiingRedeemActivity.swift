//
//  TastiingRedeemActivity.swift
//  Tastii
//
//  Created by Terry Bu on 12/11/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import Foundation

class TastiingRedeemActivity: Activity {
    
    var redeemBuddies: [User]?
    
    init(user: User, item: Item) {
        super.init(type: ActivityType.TastiingRedeem, user: user, item:item, created: NSDate())
    }
    
    init(user: User, item: Item, redeemBuddies: [User]?) {
        super.init(type: ActivityType.TastiingRedeem, user: user, item:item, created: NSDate())
        self.redeemBuddies = redeemBuddies
    }
    
}
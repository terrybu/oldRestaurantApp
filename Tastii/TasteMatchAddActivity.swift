//
//  TasteMatchAddActivity.swift
//  Tastii
//
//  Created by Terry Bu on 12/11/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import Foundation

class TasteMatchAddActivity: Activity {
    
    
    init(user: User, item: Item) {
        super.init(type: ActivityType.TasteMatchAdd, user: user, item: item, created: NSDate())
    }
    
}
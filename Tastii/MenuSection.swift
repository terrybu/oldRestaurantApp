//
//  MenuSection.swift
//  Tastii
//
//  Created by Terry Bu on 2/25/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import Foundation

class MenuSection {
    
    var name: String
    var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    
}
//
//  User.swift
//  Tastii
//
//  Created by Terry Bu on 12/11/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String
    var lastName: String
    var userId: String?
    var imageName: String?
    var imageURLString: String?
    var email: String?
    var password: String?
    var userName: String?
    var bio: String?
    
    var isFollowedByCurrentUser = false
    
    //stats
    var followers: Int = 0
    var following: Int = 0
    var activitiesArray: [Activity]?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    convenience init(firstName: String, lastName: String, email: String, imageName: String?) {
        self.init(firstName: firstName, lastName: lastName)
        self.email = email
        self.imageName = imageName
    }
    
    convenience init(firstName: String, lastName: String, imageURLString: String?) {
        self.init(firstName: firstName, lastName: lastName)
        self.imageURLString = imageURLString
    }
    
    convenience init(firstName: String, lastName: String, imageName: String?) {
        self.init(firstName: firstName, lastName: lastName)
        self.imageName = imageName
    }
    
    
}
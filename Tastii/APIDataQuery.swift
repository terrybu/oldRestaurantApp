//
//  APIDataQuery.swift
//  Tastii
//
//  Created by Terry Bu on 1/27/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIDataQuery {
    
    static let sharedInstance = APIDataQuery()
    
    var allVenuesArray = [Venue]()
    var allItemsArray = [Item]()
    var allMenuSectionsArray = [MenuSection]()

    //Get Venues
    func getVenueDetail(venueID: String, completion: ((success: Bool) -> Void)?) {
        Alamofire.request(.GET, "http://tastii.fifthq.com/restapi/get_venue_detail/venue_id/\(venueID)")
            .responseJSON {  (response) -> Void in
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["success"] == false || json["data"]["error"] != nil{
                        if let completion = completion {
                            completion(success: false)
                        }
                    } else if (json["success"] == true) {
                        if let completion = completion {
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
    func getVenueList(completion: ((success: Bool) -> Void)?) {
        let params = ["limit" : 50, "page_no": 1]
        allVenuesArray = []
        Alamofire.request(.GET, "http://tastii.fifthq.com/restapi/get_venue_list/", parameters: params)
            .responseJSON {  (response) -> Void in
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["success"] == false || json["data"]["error"] != nil{
                        print(json)
                        print("data retrieval failed for getVenues")
                        if let completion = completion {
                            completion(success: false)
                        }
                        return
                    } else if (json["success"] == true) {
                        let objectsDict = json["data"].dictionaryValue
                        for object in objectsDict {
                            let venueJSON = object.1
//                            print(venueJSON)
                            if venueJSON ["venue_name"] != nil {
                                let venueName = venueJSON["venue_name"].stringValue
                                let venueID = venueJSON["id"].stringValue
                                let newVenue = Venue(name: venueName, id: venueID)
                                self.allVenuesArray.append(newVenue)
                            }
                        }
                        self.allVenuesArray.sortInPlace({ (venue1, venue2) -> Bool in
                            venue1.name < venue2.name
                        })
                        if let completion = completion {
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
    //MARK: Items
    func getItemsForVenue(venueID: String, completion: ((success: Bool, menuSectionsArray: [MenuSection]?) -> Void)?) {
        let requestString = "http://tastii.fifthq.com/restapi/get_venue_menu/venue_id/\(venueID)"
        Alamofire.request(.GET, requestString)
            .responseJSON {  (response) -> Void in
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["success"] == false || json["data"]["error"] != nil{
                        print(json["data"]["error"])
                        if let completion = completion {
                            completion(success: false, menuSectionsArray: nil)
                        }
                        return
                    } else if (json["success"] == true) {
                        let objectsDict = json["data"].dictionaryValue
                        let menusArray = objectsDict["menus"]?.arrayValue
                        print(menusArray) //Inside menus array, there's objects inside that represent things like Dinner Menu, Lunch Menu ... and inside Dinner Menu, there are sections like Appetizers, Soups and Salads
                        //Only problem is some places like 2-3 menus, some place only has Dinner menu, etc
                        //***Just do ALL SECTIONS FOR NOW
                        for menuObjectJSON in menusArray! {
                            let menuName = menuObjectJSON["name"]
                            let sectionsArrayFromJSON = menuObjectJSON["sections"].arrayValue
                            for sectionsJSON in sectionsArrayFromJSON {
                                let itemsArrayFromJSON = sectionsJSON["items"].arrayValue
                                var itemsArrayToAddToSection = [Item]()
                                for itemJSON in itemsArrayFromJSON {
                                    let name = itemJSON["item_name"].stringValue
                                    let description = itemJSON["item_description"].stringValue
                                    let price = itemJSON["price"].stringValue
                                    var newItem = Item(name: name, description: description, price: price)
                                    itemsArrayToAddToSection.append(newItem)
                                }
                                let sectionName = sectionsJSON["name"].stringValue
                                let newSection = MenuSection(name: sectionName, items: itemsArrayToAddToSection)
                                self.allMenuSectionsArray.append(newSection)
                            }
                        }
                        self.allMenuSectionsArray.sortInPlace({ (item1, item2) -> Bool in
                            item1.name < item2.name
                        })
                        if let completion = completion {
                            completion(success: true, menuSectionsArray: self.allMenuSectionsArray)
                        }
                    }
                }
        }
    }
    
    func getAllItems(completion: ((success: Bool) -> Void)?) {
        Alamofire.request(.GET, "http://tastii.fifthq.com/restapi/get_items/")
            .responseJSON {  (response) -> Void in
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["success"] == false || json["data"]["error"] != nil{
                        if let completion = completion {
                            completion(success: false)
                        }
                    } else if (json["success"] == true) {
                        if let completion = completion {
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
    //MARK: Matching Related
    func markItemAsMatchForFirstTime(item: Item, completion: ((success: Bool) -> Void)?) {
        let params = [
            "match_id": item.id!,
            "match_type": "item",
            "is_matched": true
        ]
        Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/save_taste_match/", parameters: params as? [String : AnyObject])
            .responseJSON {  (response) -> Void in
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    print(json)
                    if json["success"] == false || json["data"]["error"] != nil{
                        if let completion = completion {
                            completion(success: false)
                        }
                    } else if (json["success"] == true) {
                        if let completion = completion {
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
    func updateItemMatchOrNoMatch(item: Item, matchID: String, isMatch:Bool, completion: ((success: Bool) -> Void)?) {
        let params = [
            "id": matchID,
            //match id is either id of the item or ingredient. poor naming on api
            "match_id": item.id!,
            "match_type": "item",
            "is_matched": isMatch
        ]
        Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/save_taste_match/", parameters: params as? [String : AnyObject])
            .responseJSON {  (response) -> Void in
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    print(json)
                    if json["success"] == false || json["data"]["error"] != nil{
                        if let completion = completion {
                            completion(success: false)
                        }
                    } else if (json["success"] == true) {
                        if let completion = completion {
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
    ///Get user's taste match object for item
    func getMatchObjectForItemForCurrentUser(item: Item, completion: ((success: Bool, objectIsMatch: Bool?, matchID: String?) -> Void)?) {
        Alamofire.request(.GET, "http://tastii.fifthq.com/restapi/get_item_taste_match/match_id/\(item.id!)/match_type/item")
            .responseJSON {  (response) -> Void in
                if let data = response.result.value {
                    let json = JSON(data)
                    print("JSON Match Object Data for Item \(item.name)")
                    print(json)
                    if json["success"] == false || json["data"]["error"] != nil{
                        if let completion = completion {
                            completion(success: false, objectIsMatch: nil, matchID: nil)
                        }
                    } else if (json["success"] == true) {
                        let data = json["data"]
                        let idStringOfMatchObject = data["id"].stringValue
                        item.idStringOfMatchObject = idStringOfMatchObject
                        if data["is_matched"] == "1" {
                            //note that above, we are checking for json data of string "1" for true and below "0" for false. actually comparing it against true or false doesn't work
                            print("MATCH WITH USER:\(item.name)")
                            item.isMatchForCurrentUser = true
                            if let completion = completion {
                                completion(success: true, objectIsMatch: true, matchID: idStringOfMatchObject)
                            }
                        }
                        else if data["is_matched"] == "0" {
                            print("NO MATCH WITH USER:\(item.name)")
                            item.isMatchForCurrentUser = false
                            if let completion = completion {
                                completion(success: true, objectIsMatch: false, matchID: idStringOfMatchObject)
                            }
                        }
                        else {
                            if let completion = completion {
                                completion(success: false, objectIsMatch: false, matchID: nil)
                            }
                        }
                    } else {
                        if let completion = completion {
                            completion(success: false, objectIsMatch: false, matchID: nil)
                        }
                    }
                }
        }
    }
    
    //Get all matched users for this item
    func getMatchedUsers(item: Item, completion: ((success: Bool, totalNumberOfMatches: Int, matchedUsers: [User]?) -> Void)) {
        Alamofire.request(.GET, "http://tastii.fifthq.com/restapi/get_matched_users/match_id/\(item.id!)/match_type/item")
            .responseJSON {  (response) -> Void in
                if let response = response.result.value {
                    let json = JSON(response)
                    print("GETTING OTHER MATCHED USERS for \(item.name)")
                    print(json)
                    if json["success"] == true {
                        let matchedUsersArray = json["data"].array
                        var returnDataArray = [User]()
                        if let matchedUsersArray = matchedUsersArray {
                            for object in matchedUsersArray {
                                let userObject = User(firstName: object["first_name"].stringValue, lastName: object["last_name"].stringValue, imageURLString: object["photo"].stringValue)
                                returnDataArray.append(userObject)
                            }
                            completion(success: true, totalNumberOfMatches: json["total"].intValue, matchedUsers: returnDataArray)
                        }
                    } else {
                        completion(success: false, totalNumberOfMatches: 0, matchedUsers: nil)
                    }
                }
        }
    }
    
    //MARK: Follow/Unfollow
    
    func followOrUnfollowUser(userID: String, follow: Bool, completion: ((success: Bool) -> Void)?) {
        var params = [
            "user_id": userID,
        ]
        if follow == true {
            params["action"] = "follow"
        } else {
            params["action"] = "unfollow"
        }
        Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/follow_user", parameters: params as [String : String])
            .responseJSON {  (response) -> Void in
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    print(json)
                    if json["success"] == false || json["data"]["error"] != nil{
                        if let completion = completion {
                            completion(success: false)
                        }
                    } else if (json["success"] == true) {
                        if let completion = completion {
                            completion(success: true)
                        }
                    }
                }
        }
    }
    
}
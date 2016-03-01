//
//  UserManager.swift
//  Tastii-ClosedBetaTesting
//
//  Created by Terry Bu on 1/22/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

private let authUsername = "tastii"
private let authPassword = "tastiiapi"
private let kFirstNameKeyForUserParams = "first name"
private let kLastNameKeyForUserParams = "last name"
private let credentialData = "\(authUsername):\(authPassword)".dataUsingEncoding(NSUTF8StringEncoding)!
private let base64Credentials = credentialData.base64EncodedStringWithOptions([])
private let headers = ["Authorization": "Basic \(base64Credentials)"]

class UserManager {
    
    static let sharedInstance = UserManager()
    //Server Basic authentication given by the ArroWebs team
    var userIsLoggedIn: Bool
    var currentUser: User?
    
    init() {
        self.userIsLoggedIn = false
    }
    
    
    //MARK: Authentication Login/LogOut
    func logInUser(email: String, password: String, completion: ((loginSuccess: Bool) -> Void)) {
        var parameters = [
            "email": email,
            "role": "user",
            "is_facebook": "0",
            "password": password
        ]
        Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/authentication/", parameters: parameters)
            .authenticate(user: authUsername, password: authPassword)
            .responseJSON {  (response) -> Void in
                if response.result.value == nil {
                    completion(loginSuccess: false)
                    return
                }
                let json = JSON(response.result.value!)
                print(json)
                if json["success"] == false || json["data"]["error"] != nil{
                    print("LOGIN FAILURE")
                    completion(loginSuccess: false)
                    return
                } else if (json["success"] == true) {
                    print("Login Success. Your User ID is " + json["data"]["id"].stringValue)
                    let userFirstName = json["data"]["first_name"].stringValue
                    let userLastName = json["data"]["last_name"].stringValue
                    let userEmail = json["data"]["email"].stringValue
                    let userPhotoURL = json["data"]["photo"].string
                    let loggedInUser = User(firstName: userFirstName, lastName: userLastName, email: userEmail, imageName: kImageNoProfilePicAvatarName)
                    if let userPhotoURL = userPhotoURL {
                        print(userPhotoURL)
                        loggedInUser.imageURLString = userPhotoURL
                    }
                    self.currentUser = loggedInUser
                    self.userIsLoggedIn = true
                    completion(loginSuccess: true)
                    return
                }
        }
    }
    
    func logOut() {
        Alamofire.request(.GET, "http://tastii.fifthq.com/restapi/logout/")
            .responseString { response in
                print("Request Success: \(response.result.isSuccess)")
                if let httpError = response.result.error {
                    print(httpError.code)
                } else {
                    //no errors
                    print("Status Code: \(response.response!.statusCode)")
                }
            }
            .responseJSON {  (response) -> Void in
                if let json = response.result.value {
                    print(json)
                    //no real need to print json here. As long as we get success = 1, then we can redirect to login screen again
                    let swiftyJson = JSON(json)
                    if swiftyJson["success"] == true {
                        print("log out success confirmed in json return data")
                        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kLogOutWasSuccessfulOnServer, object: nil))
                    }
                }
                self.currentUser = nil
                self.userIsLoggedIn = false
        }
    }
    
    func createNewUserAndLogIn(firstName: String, lastName: String, email: String, password: String, image: UIImage?, completion: ((success: Bool) -> Void)) {
        let newUser = User(firstName: firstName, lastName: lastName)
        newUser.email = email
        newUser.password = password
        newUser.imageName = kImageNoProfilePicAvatarName
        var parameters = [
            "email": email,
            "password": password,
            kFirstNameKeyForUserParams: firstName,
            kLastNameKeyForUserParams: lastName,
            "role": "user",
            "is_facebook": "false",
        ]
        
        if let image = image {
            Alamofire.upload(.POST, "http://tastii.fifthq.com/restapi/registration",
                headers: headers,
                multipartFormData: {
                    multipartFormData in
                    if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                        multipartFormData.appendBodyPart(data: imageData, name: "photo", fileName: "\(firstName)\(lastName)profilePic.png", mimeType: "image/png")
                    }
                    for (key, value) in parameters {
                        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    }
                }, encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            if response.result.isSuccess {
                                let json = JSON(response.result.value!)
                                print(json)
                                self.currentUser = newUser
                                self.currentUser!.imageURLString = json["data"]["photo"].stringValue
                                self.userIsLoggedIn = true
                                completion(success: true)
                            } else {
                                print(response.result.error.debugDescription)
                                completion(success: false)
                            }
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                        completion(success: false)
                    }
                })
        } else {
            Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/registration", parameters: parameters)
                .authenticate(user: authUsername, password: authPassword)
                .responseJSON {  (response) -> Void in
                    if response.result.isSuccess {
                        if let json = response.result.value {
                            let swiftyJSON = JSON(json)
                            print(swiftyJSON)
                            print("Create new account success. Your User ID is " + swiftyJSON["data"]["id"].stringValue)
                            self.currentUser = newUser
                            self.userIsLoggedIn = true
                            completion(success: true)
                        }
                    }
            }
        }
    }
    
    func updateUserProfile(firstName: String?, lastName: String?, password: String?, image: UIImage?) {

        var parameters = [String : String]()
        
        if let password = password {
            parameters["password"] = password
        }
        if let firstName = firstName {
            parameters[kFirstNameKeyForUserParams] = firstName
            currentUser!.firstName = firstName
        }
        if let lastName = lastName {
            parameters[kLastNameKeyForUserParams] = lastName
            currentUser!.lastName = lastName
        }
        
        if let image = image {
            Alamofire.upload(.POST, "http://tastii.fifthq.com/restapi/edit_user_profile", headers: headers, multipartFormData: {
                multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: "photo", fileName: "\(firstName!)\(lastName!)profilePic.png", mimeType: "image/png")
                }
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                }, encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            if response.result.isSuccess {
                                let json = JSON(response.result.value!)
                                print(json)
                                self.currentUser!.imageURLString = json["data"]["photo"].stringValue
                            } else {
                                print(response.result.error.debugDescription)
                            }
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        } else {
            Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/edit_user_profile", parameters: parameters)
        }
    }

    //MARK: Facebook Signup/Signin
    func signInUsingFacebook(email: String, completion: ((facebookLoginSuccess: Bool) -> Void)) {
        var parameters = [
            "email": email,
            "role": "user",
            "is_facebook": "1"
        ]
        Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/authentication/", parameters: parameters)
            .authenticate(user: authUsername, password: authPassword)
            .responseJSON {  (response) -> Void in
                if response.result.value == nil {
                    completion(facebookLoginSuccess: false)
                    return
                }
                let json = JSON(response.result.value!)
                print(json)
                if json["success"] == false || json["data"]["error"] != nil{
                    print("LOGIN FAILURE")
                    completion(facebookLoginSuccess: false)
                    return
                } else if (json["success"] == true) {
                    print("Login Success. Your User ID is " + json["data"]["id"].stringValue)
                    let userFirstName = json["data"]["first_name"].stringValue
                    let userLastName = json["data"]["last_name"].stringValue
                    let userEmail = json["data"]["email"].stringValue
                    let userPhotoURL = json["data"]["photo"].string
                    let loggedInUser = User(firstName: userFirstName, lastName: userLastName, email: userEmail, imageName: kImageNoProfilePicAvatarName)
                    if let userPhotoURL = userPhotoURL {
                        print(userPhotoURL)
                        loggedInUser.imageURLString = userPhotoURL
                    }
                    self.currentUser = loggedInUser
                    self.userIsLoggedIn = true
                    completion(facebookLoginSuccess: true)
                    return
                }
        }
    }

    func registerFacebookUserOnServer(firstName: String, lastName: String, email: String, completion: ((success: Bool) -> Void)) {
        let newUser = User(firstName: firstName, lastName: lastName)
        newUser.email = email
        var parameters = [
            "email": email,
            kFirstNameKeyForUserParams: firstName,
            kLastNameKeyForUserParams: lastName,
            "role": "user",
            "is_facebook": "1",
        ]
        Alamofire.request(.POST, "http://tastii.fifthq.com/restapi/registration", parameters: parameters)
            .authenticate(user: authUsername, password: authPassword)
            .responseJSON {  (response) -> Void in
                if response.result.isSuccess {
                    if let json = response.result.value {
                        let swiftyJSON = JSON(json)
                        print(swiftyJSON)
                        print("Create new account success. Your User ID is " + swiftyJSON["data"]["id"].stringValue)
                        self.currentUser = newUser
                        self.userIsLoggedIn = true
                        completion(success: true)
                    }
                }
        }
    }
    
    func getFacebookProfilePhoto(completion: (success: Bool)->Void) {
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                print("\(result)")
                let resultDict = result as! NSDictionary
                let dataDict = resultDict.objectForKey("data")
                let facebookProfileImageURL = dataDict!.objectForKey("url") as! String
                UserManager.sharedInstance.currentUser?.imageURLString = facebookProfileImageURL
                completion(success: true)
            } else {
                print("\(error)")
                completion(success: false)
            }
        })
    }

}
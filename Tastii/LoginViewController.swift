//
//  LoginViewController.swift
//  Tastii-ClosedBetaTesting
//
//  Created by Terry Bu on 1/20/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit
import MBProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountAction(sender: AnyObject) {
        let createAccountVC = CreateAccountViewController()
        self.presentViewController(createAccountVC, animated: true, completion: nil)
    }
    
    @IBAction func logInButtonPressed() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Trying to Log You In ..."
        if let email = emailTextField.text, password = passwordTextField.text {
            UserManager.sharedInstance.logInUser(email, password: password, completion: { loginSuccess in
                if loginSuccess == true {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.presentHomeScreenTabVC()
                } else {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    UIAlertController.presentAlert(self, alertTitle: "Login Failed", alertMessage: "Please recheck your email and password input. Or there might be an issue with the server.", confirmTitle: "OK")
                }
            })
        } else {
            UIAlertController.presentAlert(self, alertTitle: "Login Failed", alertMessage: "Please recheck your email and password. Or create new account for new user.", confirmTitle: "OK")
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    @IBAction func facebookLoginButtonPressed() {
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) -> Void in
            if (error != nil) {
                print(error)
            } else if result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,first_name,last_name,age_range,gender, birthday"], tokenString: result.token.tokenString, version: nil, HTTPMethod: "GET")
                req.startWithCompletionHandler({ (connection, result, error) -> Void in
                    print("This logged in user: \(result)")
                    if error == nil{
                        if let dict = result as? Dictionary<String, AnyObject>{
                            print("This is dictionary of user info getting from facebook:")
                            print(dict)
                            let firstName = dict["first_name"] as! String
                            let lastName = dict["last_name"] as! String
                            let email = dict["email"] as! String
                            
                            //First time user tries to use FB button, you are signing them up on our backend and they get passed through
                            //Next time they use it, we have to check if their email already exists in the server, and then LOG THEM IN
                            
                            UserManager.sharedInstance.signInUsingFacebook(email, completion: { (facebookLoginSuccess) -> Void in
                                if facebookLoginSuccess == false {
                                    //Sign-in didn't work, probably because User never registered on our server.
                                    UserManager.sharedInstance.registerFacebookUserOnServer(firstName, lastName: lastName, email: email, completion: { (success) -> Void in
                                        if success {
                                            UserManager.sharedInstance.getFacebookProfilePhoto({ (success) -> Void in
                                                if !success {
                                                    print("failed to retrieve facebook profile photo?")
                                                }
                                                self.presentHomeScreenTabVC()
                                                })
                                        } else {
                                            print("facebook user authentication failure")
                                        }
                                    })
                                } else if facebookLoginSuccess == true {
                                        UserManager.sharedInstance.getFacebookProfilePhoto({ (success) -> Void in
                                            if !success {
                                                print("failed to retrieve facebook profile photo?")
                                            }
                                            self.presentHomeScreenTabVC()
                                        })
                                }
                            })
                        }
                    }
                    else {
                        print(error)
                    }
                })
            }
        }
    }
    
    func presentHomeScreenTabVC() {
        let tabBarVC =
        UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TastiiTabBarViewController") as! TastiiTabBarViewController
        self.presentViewController(tabBarVC, animated: true, completion: nil)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

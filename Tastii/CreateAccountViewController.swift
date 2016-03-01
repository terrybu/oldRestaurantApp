//
//  CreateAccountViewController.swift
//  Tastii-ClosedBetaTesting
//
//  Created by Terry Bu on 1/21/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var firstNameTextField: TastiiPaddedTextField!
    @IBOutlet weak var lastNameTextField: TastiiPaddedTextField!
    @IBOutlet weak var emailTextField: TastiiPaddedTextField!
    @IBOutlet weak var passwordTextField: TastiiPaddedTextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var uploadPhotoButton: UIButton!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        firstNameTextField.activateLeftViewPadding = true
        lastNameTextField.activateLeftViewPadding = true
        emailTextField.activateLeftViewPadding = true
        passwordTextField.activateLeftViewPadding = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.makeImageViewTappableWithAction(profileImageView, selector: "uploadProfilePhoto", delegate: self)
    }
    
    //**Somehow the navigation bar at the top would act weirdly, not display title nor color change. very weird. Not a big problem but do we need this to be a Navigation Bar or a mock-navigation bar?
//    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController!.navigationBar.barStyle = UIBarStyle.Default
//        self.title = "CREATE ACCOUNT"
//        self.navigationController!.navigationBar.backgroundColor = UIColor.redColor()
//        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//
//        self.navigationController!.navigationBar.translucent = false
//        self.navigationController!.navigationBar.titleTextAttributes =
//            [NSForegroundColorAttributeName: UIColor.whiteColor(),
//                NSFontAttributeName: UIFont(name: "Dosis-Medium", size: 21)!]
//    }
    
    
    private func fieldsValidationPassed() -> Bool {
        if (firstNameTextField.text?.characters.count == 0 || lastNameTextField.text?.characters.count == 0 || emailTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0) {
            UIAlertController.presentAlert(self, alertTitle: "Please check your input", alertMessage: "You have left one of the fields blank. Please fill out every field.", confirmTitle: "OK")
            return false
        } else if let email = emailTextField.text {
            if isValidEmail(email) == false {
                UIAlertController.presentAlert(self, alertTitle: "Please check your email address", alertMessage: "Email address format seems to be incorrect or incomplete", confirmTitle: "OK")
                return false 
            }
        } else if let password = passwordTextField.text {
            if password.characters.count < 4 {
                UIAlertController.presentAlert(self, alertTitle: "Password too short", alertMessage: "Password needs to be 4 or more characters", confirmTitle: "OK")
                return false
            }
        }
        return true
    }
    
    //Email validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(testStr)
    }

    //MARK: IBActions
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func uploadPhotoButtonPressed(sender: AnyObject) {
        uploadProfilePhoto()
    }
    
    @objc
    private func uploadProfilePhoto() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            profileImageView.contentMode = .ScaleAspectFit
            profileImageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        if fieldsValidationPassed() {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "Signing you up ... please hold"
            if let firstName = firstNameTextField.text, lastName = lastNameTextField.text, email = emailTextField.text, password = passwordTextField.text {
                UserManager.sharedInstance.createNewUserAndLogIn(firstName, lastName: lastName, email: email, password: password, image: profileImageView.image, completion: { (success) -> Void in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    if success {
                        let tabBarVC =
                        UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TastiiTabBarViewController") as! TastiiTabBarViewController
                        self.presentViewController(tabBarVC, animated: true, completion: nil)
                    } else {
                        UIAlertController.presentAlert(self, alertTitle: "Sign Up Failure", alertMessage: "There was an error with the server. Please try again", confirmTitle: "OK")
                    }
                })
            }
        }
    }
    
    @IBAction func saveChangesAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    //MARK: Miscellaneous
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

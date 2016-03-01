//
//  EditProfileViewController.swift
//  Tastii
//
//  Created by Terry Bu on 1/6/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit
import AlamofireImage

class EditProfileViewController: SettingsSubSelectionViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var firstNameTextField: TastiiPaddedTextField!
    @IBOutlet weak var lastNameTextField: TastiiPaddedTextField!
    @IBOutlet weak var emailTextField: TastiiPaddedTextField!
    @IBOutlet weak var passwordTextField: TastiiPaddedTextField!
    @IBOutlet weak var profileImageView: UIImageView! 
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setUpUIComponents()
    }
    
    private func setUpUIComponents() {
        self.title = "Edit Profile"
        let user = UserManager.sharedInstance.currentUser!
        firstNameTextField.activateLeftViewPadding = true
        firstNameTextField.text = user.firstName
        lastNameTextField.activateLeftViewPadding = true
        lastNameTextField.text = user.lastName
        emailTextField.activateLeftViewPadding = true
        emailTextField.text = user.email
        passwordTextField.activateLeftViewPadding = true
        profileImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        profileImageView.makeImageViewTappableWithAction(profileImageView, selector: "changeProfilePhoto", delegate: self)
        let placeholderImage = UIImage(named: kImageNoProfilePicAvatarName)!
        if let imageURLString = user.imageURLString {
            profileImageView.af_setImageWithURL(NSURL(string: imageURLString)!, placeholderImage: placeholderImage, filter: nil, imageTransition: UIImageView.ImageTransition.CrossDissolve(0.1), completion: { (response) -> Void in
                if response.result.isSuccess {
                    print(response.result.value)
                } else {
                    print(response.result.error)
                }
            })
        } else {
            profileImageView.image = placeholderImage
        }
    }
    

    
    @IBAction func changeProfilePhotoButtonPressed(sender: AnyObject) {
        changeProfilePhoto()
    }
    
    @objc
    private func changeProfilePhoto() {
        print("Change profile image")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImageView.contentMode = .ScaleToFill
        profileImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveChangesButtonPressed(sender: AnyObject) {
        UserManager.sharedInstance.updateUserProfile(firstNameTextField.text, lastName: lastNameTextField.text, password: passwordTextField.text, image: profileImageView.image)
        
        UIAlertController.presentAlert(self, alertTitle: "Changes Saved", alertMessage: "Your updated information was saved in your profile.", confirmTitle: "OK")
    }
    
    convenience init() {
        self.init(nibName: "EditProfileViewController", bundle: nil)
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

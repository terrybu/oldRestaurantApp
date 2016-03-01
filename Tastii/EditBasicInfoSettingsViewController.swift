//
//  EditBasicInfoSettingsViewController.swift
//  Tastii
//
//  Created by Terry Bu on 1/6/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class EditBasicInfoSettingsViewController: SettingsSubSelectionViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet var tableView: UITableView!
    var activeTextField: UITextField?
    let genderPickerViewOptions = ["Male", "Female"]
    var doneToolBar: UIToolbar!
    
    static let sharedInstance = EditBasicInfoSettingsViewController()
    
    convenience init() {
        self.init(nibName: "EditBasicInfoSettingsViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EDIT INFO"
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 22))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonPressedFromDatePickerToolBar")
        doneButton.tintColor = UIColor.blackColor()
        doneToolBar.items = [flexButton, doneButton]
        doneToolBar.sizeToFit()
        
        tableView.registerNib(UINib(nibName: "PrivateInformationEditCell", bundle: nil), forCellReuseIdentifier: "PrivateInformationEditCellIdentifier")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrivateInformationEditCellIdentifier") as! PrivateInformationEditCell
        
        let paddedLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 4))
        cell.editInfoTextField.leftViewMode = UITextFieldViewMode.Always
        cell.editInfoTextField.leftView = paddedLeftView
        
        switch (indexPath.row) {
        case 0:
            cell.editInfoTextField.placeholder = "Mobile Phone"
            cell.editInfoTextField.keyboardType = UIKeyboardType.PhonePad
            cell.hideActionButton = true
            break
        case 1:
            cell.editInfoTextField.placeholder = "E-mail"
            cell.editInfoTextField.keyboardType = UIKeyboardType.EmailAddress
            cell.hideActionButton = true
            break
        case 2:
            cell.editInfoTextField.placeholder = "Birthday"
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.addTarget(self, action: "birthdayDatePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            cell.editInfoTextField.inputView = datePicker
            cell.editInfoTextField.inputAccessoryView = doneToolBar
            activeTextField = cell.editInfoTextField
            cell.hideActionButton = true
            break
        case 3:
            cell.editInfoTextField.placeholder = "Gender"
            let genderPickerView = UIPickerView()
            genderPickerView.dataSource = self
            genderPickerView.delegate = self
            cell.editInfoTextField.inputView = genderPickerView
            cell.editInfoTextField.inputAccessoryView = doneToolBar
            activeTextField = cell.editInfoTextField
            cell.hideActionButton = true
            break
        case 4:
            cell.editInfoTextField.placeholder = "Facebook"
            cell.editInfoTextField.enabled = false

            cell.actionButton.setTitle("Unlink", forState: UIControlState.Normal)
            cell.didTapButtonBlock = {
                (sender: AnyObject) -> Void in
                print("facebook button tapped testing")
            }
            break
        case 5:
            cell.editInfoTextField.placeholder = "Twitter"
            cell.editInfoTextField.enabled = false
            cell.actionButton.setTitle("Link", forState: UIControlState.Normal)
            cell.didTapButtonBlock = {
                (sender: AnyObject) -> Void in
                print("twitter button tapped testing")
            }
            break
        case 6:
            cell.editInfoTextField.placeholder = "Geolocation"
            cell.editInfoTextField.enabled = false
            cell.actionButton.setTitle("Enabled", forState: UIControlState.Normal)
            cell.didTapButtonBlock = {
                (sender: AnyObject) -> Void in
                print("Geolocation button tapped testing")
            }
            break
        case 7:
            cell.editInfoTextField.placeholder = "Push Notifications"
            cell.editInfoTextField.enabled = false
            cell.actionButton.setTitle("Set Preferences", forState: UIControlState.Normal)
            cell.actionButton.frame.size = CGSizeMake(400, cell.actionButton.frame.height)
            cell.actionButton.titleLabel!.frame.size = CGSizeMake(400, cell.actionButton.frame.height)
            cell.didTapButtonBlock = {
                (sender: AnyObject) -> Void in
                print("Push Notifications Set Preferences button tapped testing")
            }
            break
        default:
            break
        }
        cell.editInfoTextField.delegate = self
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    
    
    //MARK: UITextField Delegate Methods
    
    func doneButtonPressedFromDatePickerToolBar() {
        if let textField = activeTextField {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
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
    
    
    func birthdayDatePickerValueChanged(sender: UIDatePicker) {
        let datePicked = sender.date
        let df = NSDateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let dateString = df.stringFromDate(datePicked)
        let birthdayCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! PrivateInformationEditCell
        birthdayCell.editInfoTextField.text = dateString
    }

    
    //MARK: UIPickerViewDelegate and Data Source Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerViewOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerViewOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! PrivateInformationEditCell
        cell.editInfoTextField.text = genderPickerViewOptions[row]
    }

    
    
}

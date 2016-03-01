//
//  SettingsMenuTableViewDataSource.swift
//  Tastii
//
//  Created by Terry Bu on 12/31/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit

let kSettingsSubselectionsArray = [
    "Edit Account Info",
    "Diet And Allergies",
    "Taste Preferences",
    "Find Friends",
    "Add a Restaurant",
    "FAQ & Support",
    "Log Out"]

protocol SettingsMenuTableViewDelegate {
    func didPressMyTastePreferences()
    func didPressEditProfile()
    func didPressFAQsSupport()
    func didPressLogOut()
}

class SettingsMenuTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var headerView: SettingsMenuHeaderView!
    var delegate: SettingsMenuTableViewDelegate?
    
    override init() {
        super.init()
    }
    

    //MARK: UITableViewDataSource Methods
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "    Hello, Terry Bu"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        headerView = UIView.loadFromNibNamed("SettingsMenuHeaderView") as! SettingsMenuHeaderView
        
        return headerView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 17.0)
        cell.textLabel?.textColor = UIColor(rgba: "#777777")
        cell.textLabel!.text = kSettingsSubselectionsArray[indexPath.row]
        cell.textLabel!.textAlignment = .Center

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.delegate?.didPressEditProfile()
            break
        case 1:
            print("Diet Allergy")
        case 2:
            print("taste pref")
            self.delegate?.didPressMyTastePreferences()
            break
        case 3:
            print("Find Friends")
            break
        case 4:
            print("Add a restaurant")
            break
        case 5:
            print("FAQ Support")
            break
        case 6:
            print("Log Out ")
            self.delegate?.didPressLogOut()
            break
        default:
            //default
            break
        }
    }

    
}
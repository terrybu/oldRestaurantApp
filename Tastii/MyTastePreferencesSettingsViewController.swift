//
//  MyTastePreferencesSettingsViewController.swift
//  Tastii
//
//  Created by Terry Bu on 1/6/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit
import TagListView

class MyTastePreferencesSettingsViewController: SettingsSubSelectionViewController, TagListViewDelegate {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var neutralMatchesTagListView: TagListView!
    @IBOutlet var savedMatchesTagListView: TagListView!

    convenience init() {
        self.init(nibName: "MyTastePreferencesSettingsViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TASTE PREFERENCES"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        configureTagListView(neutralMatchesTagListView)
        neutralMatchesTagListView.delegate = self
        neutralMatchesTagListView.addTag("GUACAMOLE")
        neutralMatchesTagListView.addTag("TOMATO")
        neutralMatchesTagListView.addTag("ONION")
        neutralMatchesTagListView.addTag("GARLIC")
        neutralMatchesTagListView.addTag("GINGER")
        neutralMatchesTagListView.addTag("CHILI")
        
        configureTagListView(savedMatchesTagListView)
        savedMatchesTagListView.delegate = self
        savedMatchesTagListView.addTag("AVOCADO")
        savedMatchesTagListView.addTag("BEEF")
        savedMatchesTagListView.addTag("YOGURT")
        savedMatchesTagListView.addTag("BASIL")
        savedMatchesTagListView.tagBackgroundColor = UIColor(rgba: "#FF6B69")
        savedMatchesTagListView.textColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ingredientWasAddedAsSavedMatch:", name: kIngredientWasAddedAsSavedMatch, object: nil)
    }
    
    func ingredientWasAddedAsSavedMatch(notification: NSNotification) {
        guard let ingredientMatch = notification.object else {
            return
        }
        print("\(ingredientMatch) will be added as saved match")
        let ingredientString = ingredientMatch as! String
        savedMatchesTagListView.addTag(ingredientString.uppercaseString)
    }
    
    private func configureTagListView(tagListView: TagListView) {
        tagListView.alignment = .Center
        tagListView.textFont = UIFont(name: "SFUIDisplay-Regular", size: 16.0)!
        tagListView.cornerRadius = 4
        tagListView.borderWidth = 1.5
        tagListView.borderColor = UIColor(rgba: "#FF6B69")
        //padding refers to text inside the tag in relative to its borders
        tagListView.paddingY = 5
        tagListView.paddingX = 20
        //margin refers to distance between each tag
        tagListView.marginX = 10
        tagListView.marginY = 10
    }
    
    //MARK: TagListView Delegate
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        TagColorEffectHandler.sharedInstance.handleTagPress(tagView)
    }
    
    //MARK: IBActions were pressed
    @IBAction func segmentedControlValueChanged(segmentedControl: UISegmentedControl) {
        
    }
    
    @IBAction func addMatchesSearchButtonWasPressed(sender: UIButton) {
        let matchesAddViewController = MatchesAddViewController()
        self.navigationController?.pushViewController(matchesAddViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

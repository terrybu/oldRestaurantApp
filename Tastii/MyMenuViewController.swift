//
//  MyMenuViewController.swift
//  Tastii
//
//  Created by Terry Bu on 12/9/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import TagListView

enum MyMenuSegmentedControlMode: Int {
    case All = 0,
    Specials = 1,
    MyList = 2,
    TasteMatches = 3
}

class MyMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TagListViewDelegate {
    
    var allItemsArray = [Item]()
    var onlySpecialsArray: [Item]?
    var onlyMenuItemsArray: [Item]?
    var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertSegmentedControlInsideNavigationBar()
        tableView.registerNib(UINib(nibName: "SpecialsTableViewCell", bundle: nil), forCellReuseIdentifier: "SpecialsTableViewCell")
        tableView.registerNib(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuItemTableViewCell")
        
        let burger = Item(name: "Avocado Burger and Sweet Potato Fries", imageName: "avocadoBurger")
        burger.description = "Fresh avocado, lettuce, tomato, ranch dressing & mayo on a multigrain bun with sweet potato fries"
        burger.itemType = .Special
        allItemsArray.append(burger)
        
        let pestoPasta = Item(name: "Gluten Free Pesto Pasta menuItem#1", imageName: "pestoPasta")
        pestoPasta.description = "Ipsum bacon pdsjfapifjapsfjpasfapsf"
        pestoPasta.itemType = .MenuItem
        allItemsArray.append(pestoPasta)
        
        let wine = Item(name: "Cabernet Red Wine item #2", imageName: "wineTasting")
        wine.description = "WINE TASTES GREAT fjdpsafjadsfpajs"
        wine.itemType = .MenuItem
        allItemsArray.append(wine)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
    }
    
    private func insertSegmentedControlInsideNavigationBar() {
        let tongueFilterImage = UIImage(named: "Btn_ActivityFeed_MATCHES_INACTIVE_04")!
        segmentedControl = UISegmentedControl(items: ["ALL", "SPECIALS", "MY LIST", tongueFilterImage])
        segmentedControl.frame.size.width = (self.navigationController?.navigationBar.frame.size.width)! * 0.90
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    //MARK: TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !allItemsArray.isEmpty {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return allItemsArray.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let array = onlySpecialsArray {
                return array.count
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            if let array = onlyMenuItemsArray {
                return array.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (segmentedControl.selectedSegmentIndex) {
        case MyMenuSegmentedControlMode.All.rawValue:
            let cell = setUpCellForAllItemsTabScenario(indexPath)
            return cell
        case MyMenuSegmentedControlMode.Specials.rawValue:
            let item = onlySpecialsArray![indexPath.row]
            let cell = getSpecialsTableViewCell(indexPath, item: item)
            return cell
        case MyMenuSegmentedControlMode.MyList.rawValue:
            let item = onlyMenuItemsArray![indexPath.row]
            let cell = getMenuItemTableViewCell(indexPath, item: item)
            return cell
        case MyMenuSegmentedControlMode.TasteMatches.rawValue:
            break; 
        default:
            break
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    private func setUpCellForAllItemsTabScenario(indexPath: NSIndexPath) -> MyMenuTableViewCell {
        let item = allItemsArray[indexPath.row]
        if item.itemType == .Special {
            let cell = getSpecialsTableViewCell(indexPath, item: item)
            return cell
        } else {
            let cell = getMenuItemTableViewCell(indexPath, item: item)
            return cell
        }
    }
    
    private func getSpecialsTableViewCell(indexPath: NSIndexPath, item: Item) -> SpecialsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SpecialsTableViewCell", forIndexPath: indexPath) as! SpecialsTableViewCell
        cell.tag = indexPath.row
        cell.detailsButton.addTarget(self, action: "detailsButtonSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        specialsTableViewCellCustomUISetUp(cell, item: item)
        setUpTagListViewForCell(cell)
        return cell
    }
    
    private func getMenuItemTableViewCell(indexPath: NSIndexPath, item: Item) -> MenuItemTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemTableViewCell", forIndexPath: indexPath) as! MenuItemTableViewCell
        cell.tag = indexPath.row
        cell.detailsButton.addTarget(self, action: "detailsButtonSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        menuItemTableViewCellCustomUISetUp(cell, item: item)
        setUpTagListViewForCell(cell)
        return cell
    }
    
    private func specialsTableViewCellCustomUISetUp(cell: SpecialsTableViewCell, item: Item) {
        cell.backImageView.image = UIImage(named: item.imageName!)
        cell.detailsButton.setImage(UIImage(named: "Btn_MyList_DETAILSWHITE_03"
), forState: UIControlState.Normal)
        //this is just for dummy. This needs to be filled with actual users data
        cell.firstCircleImageView.image = UIImage(named: "terryFace")
        cell.secondCircleImageView.image = UIImage(named: "miashaFace")
        cell.thirdCircleImageView.image = UIImage(named: "jdFace")
        setUpLabelsForCell(cell, item: item)
    }
    
    @objc
    private func detailsButtonSelected(sender: UIButton) {
        print("details button pressed at \(sender.tag)")
    }
    
    private func menuItemTableViewCellCustomUISetUp(cell: MenuItemTableViewCell, item: Item) {
        //this is just for dummy. This needs to be filled with actual users data
        cell.firstCircleImageView.image = UIImage(named: "staff")
        cell.secondCircleImageView.image = UIImage(named: "staff2")
        cell.thirdCircleImageView.image = UIImage(named: "staff3")
        setUpLabelsForCell(cell, item: item)
    }
    
    private func setUpLabelsForCell(cell: MyMenuTableViewCell, item: Item) {
        cell.menuItemNameLabel.text = item.name
        cell.menuItemDescriptionLabel.text = item.description!
        cell.menuItemPriceDistanceLabel.text = "$12.50 - 0.3 mi"
    }
    
    private func setUpTagListViewForCell(cell: MyMenuTableViewCell) {
        cell.tagListView.delegate = self
        //This seemed necesary because cellForRowAtIndexPath was getting called repeatedly which resulted in taglistview continually adding tags through the dequeue, enqueue process
        if cell.tagsDone == false {
            let beefBurgerTag = cell.tagListView.addTag("BEEF BURGER")
            TagColorEffectHandler.sharedInstance.makeTagViewLiked(beefBurgerTag, animated: false)
            cell.tagListView.addTag("GUACAMOLE")
            cell.tagsDone = true
        }
    }
    
    //MARK: TableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 310
    }
    

    //MARK: TagListView Delegate
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        TagColorEffectHandler.sharedInstance.handleTagPress(tagView)
    }
    
    //MARK: IBActions
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case MyMenuSegmentedControlMode.All.rawValue:
            print("ALL")
            tableView.reloadData()
            break
        case MyMenuSegmentedControlMode.Specials.rawValue:
            print("SHOW ONLY SPECIALS")
            onlySpecialsArray = allItemsArray.filter({ (tasteItem) -> Bool in
                return tasteItem.itemType == .Special
            })
            tableView.reloadData()
            break
        case MyMenuSegmentedControlMode.MyList.rawValue:
            print("SHOW MYMENU ITEMS that you saved as you wanted to try them")
            onlyMenuItemsArray = allItemsArray.filter({ (tasteItem) -> Bool in
                return tasteItem.itemType == .MenuItem
            })
            tableView.reloadData()
            break
        case MyMenuSegmentedControlMode.TasteMatches.rawValue:
            print("Taste Matches that are confirmed as your matches")
            tableView.reloadData()
            break
        default:
            break
        }
    }
}

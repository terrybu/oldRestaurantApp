//
//  DiscoverViewController.swift
//  Tastii
//
//  Created by Terry Bu on 12/9/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import MBProgressHUD

private enum DiscoverOption: Int {
    case Dishes = 0, Restaurants = 1
}

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var topSalmonView: UIView! 
    
    var allVenueNamesArray = [Venue]()
    var filteredItemResults = [Item]()
    var filteredVenueResults = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Getting All Venues ... "
        APIDataQuery.sharedInstance.getVenueList { (dataQuerySuccess) -> Void in
            self.allVenueNamesArray = APIDataQuery.sharedInstance.allVenuesArray
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            })
        }
        
        APIDataQuery.sharedInstance.getAllItems { (dataQuerySuccess) -> Void in
            //
        }
        
        configureSearchController()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
//        let newView = UIView(frame: CGRectMake(36, 32.0, self.view.frame.width * 0.80, 44))
//        newView.addSubview(searchController.searchBar)
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.tastiiDarkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Dosis-Medium", size: 21)!]
        searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setImage(UIImage(named: "search"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);
    }
    
    //MARK: UISearchResultsUpdating Protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print(searchController.searchBar.text)
        let filteredArray = allVenueNamesArray.filter { (venue: Venue) -> Bool in
            return venue.name.lowercaseString.hasPrefix(searchController.searchBar.text!.lowercaseString)
        }
        filteredVenueResults = filteredArray
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == DiscoverOption.Dishes.rawValue {
            return filteredItemResults.count
        } else if segmentedControl.selectedSegmentIndex == DiscoverOption.Restaurants.rawValue{
            if searchController.searchBar.text != nil && searchController.searchBar.text?.characters.count > 0  {
                return filteredVenueResults.count
            }
        }
        return allVenueNamesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if segmentedControl.selectedSegmentIndex == DiscoverOption.Dishes.rawValue  {
            cell.textLabel?.text = filteredItemResults[indexPath.row].name
        } else if segmentedControl.selectedSegmentIndex == DiscoverOption.Restaurants.rawValue{
            if searchController.searchBar.text != nil && searchController.searchBar.text?.characters.count > 0 {
                cell.textLabel?.text = filteredVenueResults[indexPath.row].name
            }
            else {
                //if not, we display everything
                cell.textLabel?.text = allVenueNamesArray[indexPath.row].name
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == DiscoverOption.Restaurants.rawValue {
            var venue: Venue?
            if let searchBarText = searchController.searchBar.text {
                if searchBarText.characters.count > 0 {
                    venue = filteredVenueResults[indexPath.row]
                }
                else if searchController.isBeingPresented() {
                    venue = filteredVenueResults[indexPath.row]
                }
                else {
                    venue = allVenueNamesArray[indexPath.row]
                }
            }
            if let venue = venue {
                let venueMenuVC = VenueMenuViewController()
                venueMenuVC.venue = venue
                self.navigationController?.pushViewController(venueMenuVC, animated: true)
            }
        }
    }

    //MARK: IBActions
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        
        tableView.reloadData()
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}

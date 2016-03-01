//
//  MatchesAddViewController.swift
//  Tastii
//
//  Created by Terry Bu on 1/7/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class MatchesAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating  {
    
    @IBOutlet var tableView: UITableView! 
    var searchController: UISearchController!
    
    var ingredientsStringArray = ["Anchovy", "Beef", "Beet", "Tomato", "Turkey", "Bacon", "Couscous", "Kidney Beans", "Cream", "Foie gras", "Tuna", "Salmon", "Pork", "Chicken", "Cabbage", "Garlic", "Ginger"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Matches"
        ingredientsStringArray = ingredientsStringArray.sort { (s1, s2) -> Bool in
            return s2 > s1
        }
        configureSearchController()
    }
    
    func configureSearchController() {
        let searchResultsVC = SearchResultsViewController()
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search for ingredients"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true //this line makes sure that searchbar doesn't fly off the screen when searchbar gets activated weird.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: UISearchResultsUpdating Protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //leave for now
        print(searchController.searchBar.text)
        let resultsController = searchController.searchResultsController as! SearchResultsViewController
        let filteredArray = ingredientsStringArray.filter { (string: String) -> Bool in
            return string.lowercaseString.hasPrefix(searchController.searchBar.text!.lowercaseString)
            
            //Alternative: this is for checking the entire string for characters in the searchbar ("contains") check
//            let stringMatch = string.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
//            return stringMatch != nil
        }
        resultsController.filteredResults = filteredArray
        resultsController.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsStringArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ingredientsStringArray[indexPath.row]
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let newIngredientToAddAsMatch = ingredientsStringArray[indexPath.row]
        navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kIngredientWasAddedAsSavedMatch, object: newIngredientToAddAsMatch))
    }
    
    

}

//
//  VenueDetailViewController.swift
//  Tastii
//
//  Created by Terry Bu on 2/25/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var hours: UILabel! 
    var venue: Venue!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = venue.title
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell.textLabel!.text = "Make a Reservation"
        case 1:
            cell.textLabel!.text = "Directions"
        case 2:
            cell.textLabel!.text = "Call"
        case 3:
            cell.textLabel!.text = "View Full Menu"
        default:
            break
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//
//  ItemDetailViewController.swift
//  Tastii
//
//  Created by Terry Bu on 12/30/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import TagListView
import MapKit

class ItemDetailViewController: UIViewController, UITextViewDelegate, TagListViewDelegate {
    
    var item: Item!
    @IBOutlet var tasteItemImageView: UIImageView! 
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var itemDescriptionTextView: UITextView!
    @IBOutlet var addToMyListButton: UIButton!
    @IBOutlet var firstCircleImageView: UIImageView!
    @IBOutlet var secondCircleImageView: UIImageView!
    @IBOutlet var thirdCircleImageView: UIImageView!
    @IBOutlet var tasteMatchTagListView: TagListView!
    @IBOutlet var unknownTagListView: TagListView!
    @IBOutlet var notMatchesTagListView: TagListView!
    @IBOutlet var mapImageViewForRestaurantLocation: UIImageView!
    @IBOutlet var addToMyListButton2: UIButton!
    @IBOutlet var mapView: MKMapView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasteItemImageView.image = UIImage(named:item.imageName!)
        shareButton.imageView?.contentMode = UIViewContentMode.ScaleToFill
        itemDescriptionTextView.delegate = self
        makeAddToMyListButtonUI(addToMyListButton)
        makeAddToMyListButtonUI(addToMyListButton2)
        firstCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        secondCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        thirdCircleImageView.circleImageViewSetUp(UIColor(rgba: "#ff6b69"))
        //dummy exception but making third circle imageview gray border
        thirdCircleImageView.layer.borderColor = UIColor.grayColor().CGColor
        
        setUpTagsForItem()
        mapView.delegate = self
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 40.722689, longitude: -73.9833)
        centerMapOnLocation(initialLocation)
        // show restaurant on map
        let restaurant = Venue(name: "Venue Name", coordinate: CLLocationCoordinate2D(latitude: 40.722689, longitude: -73.9833), title: "Root & Bone", subtitle: "Elevated Southern fare, barrel-aged cocktails & brown booze in a small rustic space with a market")
        mapView.addAnnotation(restaurant)
    }
    
    let regionRadius: CLLocationDistance = 1000 //1000 meters, 1KM
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        //setRegion tells mapView to display the region. The map view automatically transitions the current view to the desired region with a neat zoom animation, with no extra code required!
    }
    
    private func setUpTagsForItem() {
        let beefBurgerTag = tasteMatchTagListView.addTag("BEEF BURGER")
        TagColorEffectHandler.sharedInstance.makeTagViewLiked(beefBurgerTag, animated: false)
        standardCustomizeTagListView(tasteMatchTagListView)
        
        let guacamoleTag = unknownTagListView.addTag("GUACAMOLE")
        TagColorEffectHandler.sharedInstance.makeTagViewNeutral(guacamoleTag, animated: false)
        standardCustomizeTagListView(unknownTagListView)
        
        let mayoTag = notMatchesTagListView.addTag("MAYONNAISE")
        TagColorEffectHandler.sharedInstance.makeTagViewDisliked(mayoTag, animated: false)
        standardCustomizeTagListView(notMatchesTagListView)
    }
    
    private func makeAddToMyListButtonUI(button: UIButton) {
        button.layer.borderColor = UIColor(rgba: "#54EACE").CGColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 10
    }
    
    private func standardCustomizeTagListView(tagListView: TagListView) {
        tagListView.alignment = .Center
        tagListView.delegate = self
    }

    
    //MARK: IBActions
    @IBAction func backButtonPressed() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: TagListView Delegate
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        TagColorEffectHandler.sharedInstance.handleTagPress(tagView)
    }

}

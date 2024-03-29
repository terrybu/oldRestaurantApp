//
//  BrowseViewController.swift
//  Tastii
//
//  Created by Terry Bu on 12/9/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import Koloda

class BrowseViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var nearbySwitch: TealSwitch!

    var itemsArray = [Item]()
    private var numberOfCards: UInt!

    var draggableCardIsExpanded: Bool = false
    var originalFrame: CGRect?
    var originalCardFrame: CGRect?
    var bottomUpView: UIView?
    var closeXButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUpTasteItemsArrayWithDummyTasteItems()
        numberOfCards = UInt(itemsArray.count)
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        let font = UIFont(name: "SFUIDisplay-Regular", size: 16.0)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: font!],
            forState: UIControlState.Normal)
    }
    
    private func fillUpTasteItemsArrayWithDummyTasteItems() {
        let burger = Item(name: "Avocado Burger and Sweet Potato Fries", imageName: "avocadoBurger")
        burger.description = "Fresh avocado, lettuce, tomato, ranch dressing & mayo on a multigrain bun with sweet potato fries"
        burger.itemType = .Special
        itemsArray.append(burger)
        
        let pestoPasta = Item(name: "Gluten Free Pesto Pasta menuItem#1", imageName: "pestoPasta")
        pestoPasta.description = "Ipsum bacon pdsjfapifjapsfjpasfapsf"
        pestoPasta.itemType = .MenuItem
        itemsArray.append(pestoPasta)
        
        let wine = Item(name: "Cabernet Red Wine item #2", imageName: "wineTasting")
        wine.description = "WINE TASTES GREAT fjdpsafjadsfpajs"
        wine.itemType = .MenuItem
        itemsArray.append(wine)
    }
    
    @objc
    private func locationIconButtonWasPressed() {
        print("location button press")
        let modalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalVC")
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: KolodaViewDataSource
    func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
        return numberOfCards
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let browseCardView = NSBundle.mainBundle().loadNibNamed("BrowseCardView", owner: nil, options: nil)[0] as! BrowseCardView
        browseCardView.foodItemImageView.image = UIImage(named: itemsArray[Int(index)].imageName!)
        browseCardView.foodItemImageView.layer.cornerRadius = 5
        browseCardView.layer.cornerRadius = 5
        browseCardView.layer.borderColor = UIColor(rgba:"#aaaaaa").CGColor
        return browseCardView
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? CustomOverlayView
    }

    
    //MARK: KolodaViewDelegate
    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        //Example: loading more cards
        if index >= 3 {
            numberOfCards = 6
            kolodaView.reloadData()
        }
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        kolodaView.resetCurrentCardNumber()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        print("card tapped at index \(index)")
        let item = itemsArray[Int(index)]
        let detailViewController = ItemDetailViewController(nibName: "ItemDetailViewController", bundle: nil)
        detailViewController.item = item
        presentViewController(detailViewController, animated: true, completion: nil)
    }
    

}

//
//  TagColorEffectHandler
//  Tastii
//
//  Created by Terry Bu on 12/28/15.
//  Copyright © 2015 Tastii. All rights reserved.
//

import UIKit
import TagListView

enum TagMode: Int {
    case Neutral = 0,
    Liked = 1,
    Disliked = 2
}

class TagColorEffectHandler {
    
    static let sharedInstance = TagColorEffectHandler()
    
    func handleTagPress(tagView:TagView) {
        if tagView.tag == TagMode.Neutral.rawValue {
            makeTagViewLiked(tagView, animated: true)
        } else if tagView.tag == TagMode.Liked.rawValue {
            tagView.tag = TagMode.Disliked.rawValue
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                tagView.backgroundColor = UIColor.grayColor()
                tagView.layer.borderColor = UIColor.grayColor().CGColor
                tagView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }, completion: nil)
        } else if tagView.tag == TagMode.Disliked.rawValue {
            tagView.tag = TagMode.Neutral.rawValue
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                tagView.backgroundColor = UIColor.whiteColor()
                tagView.layer.borderColor = UIColor(rgba: "#ff6b69").CGColor
                tagView.setTitleColor(UIColor(rgba: "#ff6b69"), forState: UIControlState.Normal)
                }, completion: nil)
        }
    }
    
    //TagView Related
//    func makeLikedAtTagListViewIndex(tagListView: TagListView, index: Int) {
//        let tagView = tagListView.tagViews[index]
//        UIView.animateWithDuration(0.35, animations: { () -> Void in
//            tagView.tagBackgroundColor = UIColor(rgba: "#ff6b69")
//            tagView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//            }, completion: nil)
//    }
    
    func makeTagViewLiked(tagView: TagView, animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                tagView.tagBackgroundColor = UIColor(rgba: "#ff6b69")
                tagView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }, completion: { (completed)  -> Void in
                    tagView.tag = TagMode.Liked.rawValue
            })
        } else {
            tagView.tagBackgroundColor = UIColor(rgba: "#ff6b69")
            tagView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            tagView.tag = TagMode.Liked.rawValue
        }
    }
    
    func makeTagViewNeutral(tagView: TagView, animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                tagView.backgroundColor = UIColor.whiteColor()
                tagView.layer.borderColor = UIColor(rgba: "#ff6b69").CGColor
                tagView.setTitleColor(UIColor(rgba: "#ff6b69"), forState: UIControlState.Normal)
                }, completion: { (completed)  -> Void in
                    tagView.tag = TagMode.Neutral.rawValue
            })
        } else {
            tagView.backgroundColor = UIColor.whiteColor()
            tagView.layer.borderColor = UIColor(rgba: "#ff6b69").CGColor
            tagView.setTitleColor(UIColor(rgba: "#ff6b69"), forState: UIControlState.Normal)
            tagView.tag = TagMode.Neutral.rawValue
        }
    }
    
    func makeTagViewDisliked(tagView: TagView, animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                tagView.backgroundColor = UIColor.grayColor()
                tagView.layer.borderColor = UIColor.grayColor().CGColor
                tagView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }, completion: { (completed)  -> Void in
                    tagView.tag = TagMode.Disliked.rawValue
            })
        } else {
            tagView.backgroundColor = UIColor.grayColor()
            tagView.layer.borderColor = UIColor.grayColor().CGColor
            tagView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            tagView.tag = TagMode.Disliked.rawValue
        }
    }
    
    
    
}
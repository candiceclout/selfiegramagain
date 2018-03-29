//
//  SelfieCell.swift
//  selfiegramagain
//
//  Created by Luca Morellato on 2018-03-14.
//  Copyright © 2018 candice. All rights reserved.
//

import UIKit
import Parse

class SelfieCell: UITableViewCell {
    
    var post:Post? {
        
        didSet{
            if let post = post {
                selfieImageView.image = nil
                
                let imageFile = post.image
                imageFile.getDataInBackground(block: {(data, error) -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                })
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
            }
        }
    }
    
    
    @IBOutlet weak var selfieImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let post = post,
            let user = PFUser.current() {
            if sender.isSelected {
                if sender.isSelected {
                    
                    post.likes.add(user)
                    
                    post.saveInBackground(block: { (success, error) -> Void in
                        if success {
                            print("like from user successfully saved")
                            
                            // Creating an row in the Activity table
                            // Saving it as a "like" type
                            let activity = Activity(type: "like", post: post, user: user)
                            activity.saveInBackground(block: { (success, error) -> Void in
                                print("activity successfully saved")
                            })
                            
                            
                        }else{
                            print("error is \(String(describing: error))")
                        }
                    })
                    
                    
                }
                
                
                
            }else{
                // PFRelation also has a useful method called removeObject that removes
                // the element if there is an element to be removed.
                post.likes.remove(user)
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("like from user successfully removed")
                        
                        //PFQuery to find the like activity
                        if let activityQuery = Activity.query(){
                            activityQuery.whereKey("post", equalTo: post)
                            activityQuery.whereKey("user", equalTo: user)
                            activityQuery.whereKey("type", equalTo: "like")
                            activityQuery.findObjectsInBackground(block: { (activities, error) -> Void in
                                
                                
                                // You should only have one like activity from a user
                                // but this is code is being safe and checking for one or multiple instances
                                // and then deleting all of them
                                if let activities = activities {
                                    for activity in activities {
                                        activity.deleteInBackground(block: { (success, error) -> Void in
                                            print("deleted activity")
                                        })
                                    }
                                }
                            })
                        }
                        
                    }else{
                        print("error is \(error)")
                    }
                })
                
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

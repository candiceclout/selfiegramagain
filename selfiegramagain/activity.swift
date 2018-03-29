//
//  activity.swift
//  selfiegramagain
//
//  Created by Luca Morellato on 2018-03-28.
//  Copyright © 2018 candice. All rights reserved.
//

import Foundation

import Parse

class Activity:PFObject, PFSubclassing {
    
    @NSManaged var type:String
    @NSManaged var post:Post
    @NSManaged var user:PFUser
    
    static func parseClassName() -> String {
        return "Activity"
    }
    
    convenience init(type:String, post:Post, user:PFUser){
        self.init()
        self.type = type
        self.post = post
        self.user = user
    }
    
}

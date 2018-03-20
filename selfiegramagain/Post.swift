//
//  Post.swift
//  selfiegramagain
//
//  Created by Luca Morellato on 2018-03-09.
//  Copyright © 2018 candice. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    let imageURL:URL
    let user:User
    let comment:String
    
    init(imageURL:URL, user:User, comment:String){
      
        self.imageURL = imageURL
        self.user = user
        self.comment = comment
    }
    
}

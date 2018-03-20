//
//  User.swift
//  selfiegramagain
//
//  Created by Luca Morellato on 2018-03-07.
//  Copyright © 2018 candice. All rights reserved.
//
import Foundation
import UIKit

class User {
    
    let username:String
    let profileImage:UIImage
    
    init(aUsername:String, aProfileImage:UIImage){
        //we are setting the User property of "username" to an aUsername property you are going to pass in
        username = aUsername
        profileImage = aProfileImage
    }
    
}

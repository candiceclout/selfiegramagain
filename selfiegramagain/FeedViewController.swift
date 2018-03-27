//
//  FeedViewController.swift
//  selfiegramagain
//
//  Created by Luca Morellato on 2018-03-12.
//  Copyright © 2018 candice. All rights reserved.
//

import UIKit
import Parse


class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var words = ["Hello", "my", "name", "is", "Selfigram"]
    var posts = [Post]()

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
           
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.current(){
                
                
                let post = Post(image: imageFile, user: user, comment: "A Selfie")
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("Post successfully saved in Parse")
                        
                      
                        self.posts.insert(post, at: 0)
                        
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
        
    }

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = Post.query() {
            query.order(byDescending: "createdAt")
            query.includeKey("user")
            
            query.findObjectsInBackground(block: { (posts, error) -> Void in
                
                if let posts = posts as? [Post]{
                    self.posts = posts
                    self.tableView.reloadData()
                }
                
            })
        }
    }


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.posts.count
}

override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 320
}


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        
        let post = self.posts[indexPath.row]
        
        // I've added this line to prevent flickering of images
        // We are inside the cellForRowAtIndexPath method that gets called everytime we lay out a cell
        // This always resets the image to blank, waits for the image to download, and then sets it
        cell.selfieImageView.image = nil
        
        let imageFile = post.image
        imageFile.getDataInBackground(block: {(data, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                cell.selfieImageView.image = image
            }
        })
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        return cell
    }



@IBAction func cameraButtonPressed(_ sender: Any) {
    
    print("Camera Button Pressed")
    
    let pickerController = UIImagePickerController()
    
    pickerController.delegate = self
    
    if TARGET_OS_SIMULATOR == 1 {
        
        pickerController.sourceType = .photoLibrary
    } else {
        
        pickerController.sourceType = .camera
        pickerController.cameraDevice = .front
        pickerController.cameraCaptureMode = .photo
    }
    self.present(pickerController, animated: true, completion: nil)
    }
    
  
    
}

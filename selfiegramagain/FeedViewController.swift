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
            
            // setting the compression quality to 90%
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.current(){
                
                //2. We create a Post object from the image
                let post = Post(image: imageFile, user: user, comment: "A Selfie")
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("Post successfully saved in Parse")
                        
                        //3. Add post to our posts array, chose index 0 so that it will be added
                        //   to the top of your table instead of at the bottom (default behaviour)
                        self.posts.insert(post, at: 0)
                        
                        //4. Now that we have added a post, updating our table
                        //   We are just inserting our new Post instead of reloading our whole tableView
                        //   Both method would work, however, this gives us a cool animation for free
                        
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

    
    
    // We use OperationQueue.main because we need update all UI elements on the main thread.
//    // This is a rule and you will see this again whenever you are updating UI.
//    OperationQueue.main.addOperation {
//    self.tableView.reloadData()
//    }
//}
//
//}else{
//    print("error with response data")
//}
//
//})


// this is called to start (or restart, if needed) our task
//task.resume()



//        let me = User(aUsername: "Candice", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//        let post0 = Post(image: UIImage(named: "BigHorn")!, user: me, comment: "Big Horn")
//        let post1 = Post(image: UIImage(named: "coyote")!, user: me, comment: "Coyote")
//        let post2 = Post(image: UIImage(named: "roadrunner")!, user: me, comment: "Roadrunner")
//        let post3 = Post(image: UIImage(named: "scorpion")!, user: me, comment: "Scorpion")
//        let post4 = Post(image: UIImage(named: "rattlesnake")!, user: me, comment: "Rattlesnake")
////
//        posts = [post0, post1, post2, post3, post4]
//
// Uncomment the following line to preserve selection between presentations
// self.clearsSelectionOnViewWillAppear = false

// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
// self.navigationItem.rightBarButtonItem = self.editButtonItem
//}

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

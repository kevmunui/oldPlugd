//
//  registerPlaceViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/21/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class registerPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var placeNameemailTextField: UITextField!
    var placePageData:NSMutableArray = NSMutableArray()
    @IBOutlet weak var profile_picture: UIImageView!
    var placeUser: PFObject = PFObject(className: "placeTable")
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  userEmail = PFUser.currentUser()?.objectForKey("email") as! String
        
        
        emailTextField.text = userEmail
        // = placeNamer
        
//        profile_picture.clipsToBounds = true
//        profile_picture.layer.borderColor = UIColor.blackColor().CGColor
//        profile_picture.layer.borderWidth =  2
        // Do any additional setup after loading the view.
        
        
       // var business:PFQuery = PFUser.query()!
        let businessObject:PFObject = PFObject(className:"placeName")
        let query = PFQuery(className:"placeName")
        query.whereKey("userName", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if (error == nil) {
                
                if let objects = objects as? [PFObject]{
                    for object in objects{
                        self.placePageData.addObject(object)
                        
                    }
                    
                }
                
                
                
                
               // let array:NSArray = self.placePageData.reverseObjectEnumerator().allObjects
                
                
                self.placeNameemailTextField.text  = businessObject.objectForKey("placeName") as? String
                
                
            }
            else {
                print("something wrong went on!", terminator: "")
            }
        
        })
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerButtonTapped(sender: UIButton) {
        
        
        let myUser:PFUser =  PFUser.currentUser()!
        let userEmail = emailTextField.text
        let placeName = placeNameemailTextField.text
        let userPlaceImage = profile_picture.image
       
        
        
        placeUser["user"] = myUser
        placeUser["placeName"] = placeName
        placeUser["placeImage"] = userPlaceImage
        
        placeUser.saveInBackground()
        
        
        
        
        func displayAlertmsg(userMessage:String){
            
            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }
        
        //prevent empty
        
        
        
        
        if(userEmail!.isEmpty || placeName!.isEmpty ){
            //Display alert message
            displayAlertmsg("All fields are required!")
            return
            
        }
        
        
        self.navigationController?.popToRootViewControllerAnimated(true)
      
        
     
        
    }
    
    @IBAction func accountButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func selectProfilePicture(sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        profile_picture.image = info[UIImagePickerControllerOriginalImage] as?
        UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SecondViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 8/16/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

var blogName : String?



class SecondViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    let myUser:PFUser =  PFUser.currentUser()!

    var options = [ ]
    var inviteType = " "
    var clicked = true

    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var PlacePicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("this is something \(blogName)", terminator: "")
      
        
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK", terminator: "")
        } else {
            print("Internet connection FAILED", terminator: "")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }

        // Do any additional setup after loading the view.
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //check error 
    func displayAlertmsg(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo!", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        
                
        
        self.presentViewController(myAlert, animated: true, completion: nil)

    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
      //  self.dismissViewControllerAnimated(true, completion: nil)
        
               let secondViewController:placeHomeViewController = placeHomeViewController()
        
              self.presentViewController(secondViewController, animated: true, completion: nil)
        
        

    }
    
    
    @IBAction func inviteOnly(sender: UIButton) {
        
        sender.enabled = self.clicked
        if(sender.enabled){
            self.inviteType = "Invite only"
        }
        self.clicked = false
    }
    
    @IBAction func openEvent(sender: UIButton) {
        sender.enabled = self.clicked
        if(sender.enabled){
            self.inviteType = "open"
        }
        self.clicked = false
    }
    
    @IBAction func selectProfilePicture(sender: UIButton) {
        
        let myPickerCtr = UIImagePickerController()
        myPickerCtr.delegate = self
        
        myPickerCtr.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerCtr, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        PlacePicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    @IBAction func createButton(sender: UIBarButtonItem) {
        
        
        print("the id is \(blogName)", terminator: "")
        
        let imageDataProfile = UIImageJPEGRepresentation(self.PlacePicture.image!,1)
        
        let findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.whereKey("user", equalTo: myUser)
        findPlaceData.whereKey( "objectId", equalTo: blogName!)
        
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                print("saved the object")
                print(self.myUser)
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        
                        
                        
                        let dateString = self.date.text
                        
                        
                        
                        
                        //saving the picture
                        
                        object.setValue(self.inviteType, forKey: "inviteType")
                        object.setValue(dateString!, forKey: "partyDate")
                        
                        if (imageDataProfile != nil){
                            let profileFileObject = PFFile(data:imageDataProfile!)
                            object.setValue(profileFileObject, forKey: "place_picture")
                        }
                        
                        
                        
                        
                        
                        
                        
                        object.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
                            
                            //hide notification bar
                            
                            if(NSError != nil){
                                
                                self.displayAlertmsg("An error occured while creating an event!")
                                return
                                
                            }else if(succeeded){
                                
                                //self.displayAlertmsg("Your event has been created!")

                                self.performSegueWithIdentifier("backtomore", sender: sender)
                                
                                
                                return
                                
                            }else{
                                self.displayAlertmsg("An error occured while creating an event!")
                                return
                            }
                        }
                        
                        
                    }
                    
                }
                else{
                    
                    self.displayAlertmsg("\(error)")
                    
                    
                }
                
            }
            
        })
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}

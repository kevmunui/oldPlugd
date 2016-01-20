//
//  secondeventeditViewController.swift
//  Plugd
//
//  Created by Kevin Ndiga on 11/11/15.
//  Copyright © 2015 Plugd. All rights reserved.
//

import UIKit
import Parse

var blogNameSecond : String?



class secondeventeditViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let myUser:PFUser =  PFUser.currentUser()!
    
    var options = [ ]
    var inviteType = " "
    var clicked = true
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var PlacePicture: UIImageView!
    @IBOutlet weak var itp: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("this is something \(blogNameSecond)", terminator: "")
        
        
        
        /*the invite type*/
        
        
        let findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.whereKey( "objectId", equalTo: blogNameSecond!)
        
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                print("saved the object")
                print(self.myUser)
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        
                        let inviT = object.objectForKey("inviteType") as! String
                        let pDate = object.objectForKey("partyDate") as! String
                        
                        
                        
                        self.itp.text = inviT
                        self.date.text = pDate
                        
                     
                        //loading profile picture
                        
                        print("before we print the pic")
                        
                        if (object.objectForKey("place_picture") != nil){
                            print("there is a pic to be printed")
                            
                            let userImageFile:PFFile = (object.objectForKey("place_picture") as? PFFile)!
                            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                
                                
                                if (imageData != nil){
                                    self.PlacePicture.image = UIImage(data: imageData!)
                                }
                            })
                            
                        }else{
                            self.PlacePicture.image = UIImage(named: "Profile Picture@3x.png")
                        }
                        
                  
                        
                    
                    }
                    
                        
                }
                
            }
                else{
                    
                    self.displayAlertmsg("\(error)")
                    
                    
                }
                
        })
        
        /*end of the invite*/
      
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
    
    
    @IBAction func saveAll(sender: UIBarButtonItem) {
        
        
        print("the id is \(blogNameSecond)", terminator: "")
        
        let imageDataProfile = UIImageJPEGRepresentation(self.PlacePicture.image!,1)
        
        let findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.whereKey( "objectId", equalTo: blogNameSecond!)
        
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                print(self.myUser)
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        
                        
                        let dateString = self.date.text!
                        let itper = self.itp.text!
                        
                        
                        
                        
                        //saving the picture
                        
                        object.setValue(itper, forKey: "inviteType")
                        object.setValue(dateString, forKey: "partyDate")
                        
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
                                
                                self.performSegueWithIdentifier("backtothefirst", sender: sender)
                                
                                
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
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

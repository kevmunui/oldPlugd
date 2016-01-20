
//
//  EventCreationViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/27/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class EventCreationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var partyName: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var hostName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var placeIcon: UIImageView!
    
    

    var initialView:Float = 0
    var initialGoing:Float = 0
    var initialPopularity:Float = 0
    var clicked = false
    var newlooker = false
    let myUser:PFUser =  PFUser.currentUser()!
    var ider = String()
    var tracker:Int = 1
    
    let blogSegueIdentifier = "myEventSegue3"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //reachablity checker
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK", terminator: "")
        } else {
            print("Internet connection FAILED", terminator: "")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        //ender
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    
    //error message loader
    
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
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    
    
    
    func looker(){
    
    
        let parName = partyName.text
        let descName = desc.text
        let locaName = location.text
        let capaName = capacity.text
        let host = hostName.text
        
        print("this is before", terminator: "")
        let findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.whereKey("user", equalTo: myUser)
        findPlaceData.whereKey("host", equalTo: host!)
        findPlaceData.whereKey("partyName", equalTo: parName!)
        findPlaceData.whereKey("Description", equalTo:descName!)
        findPlaceData.whereKey("Location", equalTo: locaName!)
        findPlaceData.whereKey("Capacity", equalTo: capaName!)
        
        
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{

                       self.newlooker = true
                       self.ider = object.objectId!
                        print("this is after \(self.ider)", terminator: "")

                         blogName = self.ider
                        
                        self.performSegueWithIdentifier("myEventSegue3", sender: object.objectId)

                        
                        //self.getter()

                        
                       return
                    }
                    
                }
                
                
            }
            
        })

  
    }
    
    
    @IBAction func selectProfilePicture(sender: UIButton) {
        
        let myPickerCtr = UIImagePickerController()
        myPickerCtr.delegate = self
        
        myPickerCtr.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerCtr, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        placeIcon.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    
    
    @IBAction func `nextButton`(sender: UIBarButtonItem) {
        
        // get current user
        if(partyName.text!.isEmpty || desc.text!.isEmpty || location.text!.isEmpty || hostName.text!.isEmpty || price.text!.isEmpty || capacity.text!.isEmpty
            ){
                
                //Display alert message
                displayAlertmsg("All fields are required!")
                return
        }
        //self.looker()
        
        
        
        let parName = partyName.text
        let descName = desc.text
        let locaName = location.text
        let capaName = capacity.text
        let host = hostName.text
        
        print("this is before clicked", terminator: "")
        let findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.whereKey("user", equalTo: myUser)
        findPlaceData.whereKey("host", equalTo: host!)
        findPlaceData.whereKey("partyName", equalTo: parName!)
        findPlaceData.whereKey("Description", equalTo: descName!)
        findPlaceData.whereKey("Location", equalTo: locaName!)
        findPlaceData.whereKey("Capacity", equalTo: capaName!)
        
        
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    for _ in objects!{
                        print("this is after", terminator: "")
                        
                        self.newlooker = true
                        
                        return
                    }
                    
                }
                
                
            }
            
        })
        
        if(!self.newlooker){
            
            let userObject:PFObject = PFObject(className:"placeName")
            
            
            let parName = partyName.text
            let descName = desc.text
            let locaName = location.text
            let capaName = capacity.text
            let host = hostName.text
            let pricer = price.text
            let imageDataProfile = UIImageJPEGRepresentation(placeIcon.image!,1)
            
            
            
            //saving the picture
            
            if (imageDataProfile != nil){
                let profileFileObject = PFFile(data:imageDataProfile!)
                userObject.setObject(profileFileObject, forKey: "icon_picture")
            }
            userObject.setObject(pricer!, forKey: "price")
            userObject.setObject(host!, forKey: "host")
            userObject.setObject(parName!, forKey: "partyName")
            userObject.setObject(descName!, forKey: "Description")
            userObject.setObject(capaName!, forKey: "Capacity")
            userObject.setObject(locaName!, forKey: "Location")
            userObject.setObject(myUser, forKey: "user")
            userObject.setObject(initialView, forKey: "views")
            userObject.setObject(initialGoing, forKey: "going")
            userObject.setObject(initialPopularity, forKey: "popularity")
            
            userObject.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
                
                //hide notification bar
                
                if(NSError != nil){
                    
                    self.displayAlertmsg("An error occured while creating an event!")
                    return
                    
                }
                if(succeeded){
                    self.looker()
                    
                    return
                    
                }
                
            }
            
            
        }else{
            
            self.displayAlertmsg("the event you are trying to create already exists!")
            
        }
        
    }
    
    
    //check for only empty objects
  
    
//    func getter(){
//
//    //switch Views
//
//        
//        let secondViewController:SecondViewController = SecondViewController()
//        
//        self.presentViewController(secondViewController, animated: true, completion: nil)
//    
//    
//    }
//    

    
    


    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    



}

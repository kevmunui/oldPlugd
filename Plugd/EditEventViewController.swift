//
//  EditEventViewController.swift
//  Plugd
//
//  Created by Kevin Ndiga on 11/11/15.
//  Copyright © 2015 Plugd. All rights reserved.
//
import Parse
import UIKit

class EditEventViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    
    
    var blogName = String()
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var myPickerController: UIImageView!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var orgName: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var addr: UITextField!
    @IBOutlet weak var capacity: UITextField!

    
    
    func displayAlertmsg(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo!", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        print("loaded")
        
        super.viewDidLoad()
        /*look into the data base for this event*/
        //fetch data from the db
        let finder = PFQuery(className:"placeName")
        finder.whereKey("objectId", equalTo:blogName )
        //get count column
        
        print("we got the string" + (blogName))
        finder.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                    /*reset the values here*/
                        print("then we got into the loop")
                        
                        let placename = object.objectForKey("partyName") as! String
                        let descr = object.objectForKey("Description") as! String
                        let host = object.objectForKey("host") as! String
                        let coster = object.objectForKey("price") as! String
                        let addrr = object.objectForKey("Location") as! String
                        let numpeop = object.objectForKey("Capacity") as! String

                        
                        
                        self.eventName.text = placename
                        self.desc.text = descr
                        self.orgName.text = host
                        self.cost.text = coster
                        self.addr.text = addrr
                        self.capacity.text = numpeop
                        
                        
                        //loading profile picture
                        
                        print("before we print the pic")
                        
                        if (object.objectForKey("icon_picture") != nil){
                            print("there is a pic to be printed")
                            
                            let userImageFile:PFFile = (object.objectForKey("icon_picture") as? PFFile)!
                            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                
                                
                                if (imageData != nil){
                                    self.myPickerController.image = UIImage(data: imageData!)
                                }
                            })
                            
                        }else{
                            print("no pic")
                            self.myPickerController.image = UIImage(named: "Profile Picture@3x.png")
                        }
                        
                        

                        
    
                    }
                    
                }
                else {
                    print("\(error)", terminator: "")
                }
                
            }
            
        })
        
        
        
        /*end of look*/
        
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
    
    
    @IBAction func selectImage(sender: UIButton) {
        
        let myPickerCtr = UIImagePickerController()
        myPickerCtr.delegate = self
        
        myPickerCtr.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerCtr, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        myPickerController.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
  
    @IBAction func saveItem(sender: UIBarButtonItem) {
        
                
        
      
        
        
        // get current user
        if(eventName.text!.isEmpty || desc.text!.isEmpty || addr.text!.isEmpty || orgName.text!.isEmpty || cost.text!.isEmpty || capacity.text!.isEmpty
            ){
                
                //Display alert message
                displayAlertmsg("All fields are required!")
                return
        }
        //self.looker()
        
        
        let finder = PFQuery(className:"placeName")
        finder.whereKey("objectId", equalTo:blogName )
        finder.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                    
                        let placename = self.eventName.text!
                        let descr = self.desc.text!
                        let host = self.orgName.text!
                        let coster = self.cost.text!
                        let addrr = self.addr.text!
                        let numpeop = self.capacity.text!
                        let imageDataProfile = UIImageJPEGRepresentation(self.myPickerController.image!,1)
                        
                        
                        
                        //saving the picture
                        
                        if (imageDataProfile != nil){
                            let profileFileObject = PFFile(data:imageDataProfile!)
                            object.setObject(profileFileObject, forKey: "icon_picture")
                        }
                        
                        object.setObject(coster, forKey: "price")
                        object.setObject(host, forKey: "host")
                        object.setObject(placename, forKey: "partyName")
                        object.setObject(descr, forKey: "Description")
                        object.setObject(numpeop, forKey: "Capacity")
                        object.setObject(addrr, forKey: "Location")
                        
                        
                        
                        object.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
                            
                            //hide notification bar
                            
                            if(NSError != nil){
                                
                                self.displayAlertmsg("An error occured while creating an event!")
                                return
                                
                            }
                            if(succeeded){
                                
                               blogNameSecond = self.blogName
                               self.performSegueWithIdentifier("eventsecondeditview", sender: object.objectId)
                            }
                            
                        }
 
                        
                    }
                    
                }
                
                
            }
            
        })
        
        
        
        
    }
    
    
    
    
    
    func displayAlertmsgPrompt(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo!", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        myAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            let finder = PFQuery(className:"placeName")
            finder.whereKey("objectId", equalTo:self.blogName )
            finder.findObjectsInBackgroundWithBlock({
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    
                    if let objects = objects as? [PFObject]?{
                        for object in objects!{
                            
                            object.deleteInBackgroundWithBlock({ (Bool succeeded, error ) -> Void in
                                if(succeeded){
                                    print("gone")
                                    self.performSegueWithIdentifier("backtomain", sender: UIBarButtonItem())

                                }else{
                                
                                self.displayAlertmsg("we can not delete you event at the moment")
                                
                                }
                            })
                            

                            
                        }
                        
                    }
                    
                    
                }
                
            })
            
        }))
        
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        presentViewController(myAlert, animated: true, completion: nil)
        
    }
    

    
    @IBAction func deleteEvent(sender: UIBarButtonItem) {
        
        self.displayAlertmsgPrompt("Are you sure you want to delete this event?")
        
        
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

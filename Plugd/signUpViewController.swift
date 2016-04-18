//
//  signUpViewController.swift
//  Plugd
//
//  Created by Kevin Ndiga on 10/19/15.
//  Copyright © 2015 Plugd. All rights reserved.
//

import UIKit

import Parse

var blogName1 : String?



class signUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var PlacePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /*the circular display*/
        PlacePicture.layer.cornerRadius = PlacePicture.frame.size.width / 2
        PlacePicture.clipsToBounds = true
        PlacePicture.layer.borderColor = UIColor.purpleColor().CGColor
        PlacePicture.layer.borderWidth = 3
        
        
    
        
        
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
    
    
    func displayAlertmsgPrompt(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo!", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        myAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.performSegueWithIdentifier("backtoLogin", sender:UIAlertAction() )
        }))
        
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        presentViewController(myAlert, animated: true, completion: nil)

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
    
    
    
    
    
    
    
    
    @IBAction func createButton(sender: UIButton) {
        print("the id is \(blogName1)", terminator: "")
        
        let imageDataProfile = UIImageJPEGRepresentation(self.PlacePicture.image!,1)
        
        let findPlaceData: PFQuery = PFQuery(className: "_User")
        findPlaceData.whereKey("username", equalTo: blogName1!)
        
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                print("saved the object")

                if let objects = objects as? [PFObject]?{
                    for object in objects!{

                        
                        if (imageDataProfile != nil){
                            let profileFileObject = PFFile(data:imageDataProfile!)
                            object.setValue(profileFileObject, forKey: "profile_picture")
                        }
                        
                        
                        
                        
                        
                        
                        
                        object.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
                            
                            //hide notification bar
                            
                            if(NSError != nil){
                                
                                self.displayAlertmsg("An error occured while uploading")
                                return
                                
                            }else if(succeeded){
                                
                                self.performSegueWithIdentifier("backtoLogin", sender: sender)
                                
                                
                                return
                                
                            }else{
                                self.displayAlertmsg("An error occured while uploading!")
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
    
    
    
    
    
    @IBAction func noPictureOption(sender: UIButton) {
        self.displayAlertmsgPrompt("Are you sure you don't want to show the world your awesome smile?")
        return
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  updateProfileViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/18/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse


class updateProfileViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayAlertmsg(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo!", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }

 
    
    @IBOutlet weak var emalViewController: UITextField!
    
    @IBOutlet weak var myPickerController: UIImageView!
    @IBOutlet weak var nickNameViewController: UITextField!
    
    @IBOutlet weak var passwordViewController: UITextField!
    
    @IBOutlet weak var retypepasswordViewController: UITextField!
    
    
    
    @IBAction func saveData(sender: UIBarButtonItem) {
        
        
        
        // get current user
        let myUser:PFUser =  PFUser.currentUser()!
        
        
        let imageDataProfile = UIImageJPEGRepresentation(myPickerController.image!,1)
        
        //check if fields are empty
        
        
        
        //prevent empty
        
        
        
        
        if(emalViewController.text!.isEmpty || nickNameViewController.text!.isEmpty){
            //Display alert message
            displayAlertmsg("An email address and nick name are required!")
            return
            
        }
        
        if (!passwordViewController.text!.isEmpty && (passwordViewController.text != retypepasswordViewController.text)){
            
            //display error msg
            displayAlertmsg("Passwords do not match!")
            return
            
            
        }
        
        let userEmail = emalViewController.text
        var nickname = nickNameViewController.text
        
        /*change username to lower case to help with clean log in*/
        nickname = nickname?.lowercaseString
        /*end function*/
        
        
        myUser.setObject(userEmail!, forKey: "email")
        myUser.setObject(nickname!, forKey: "username")
        
        
        //set new password
        
        if (!passwordViewController.text!.isEmpty){
            let userPassword = passwordViewController.text
            myUser.password = userPassword
            
        }
        
        //saving the picture
        
        if (imageDataProfile != nil){
            
            let profileFileObject = PFFile(data:imageDataProfile!)
            myUser.setObject(profileFileObject, forKey: "profile_picture")
            
        }
        
        myUser.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
            
            //hide notification bar
            
            if(NSError != nil){
                
                self.displayAlertmsg("An error occured updating your profile!")
                return
                
            }
            if(succeeded){
                self.displayAlertmsg("Profile successfully updated!")
                return
                
            }
            
            
            
        }
        

        
        
        
        
    }
   
    
    
    
    
    override func viewDidLoad() {
        
        
        myPickerController.layer.cornerRadius = myPickerController.frame.size.width / 2
        myPickerController.clipsToBounds = true
        myPickerController.layer.borderColor = UIColor.purpleColor().CGColor
        myPickerController.layer.borderWidth = 3
        
        
        //reachablity checker
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK", terminator: "")
        } else {
            print("Internet connection FAILED", terminator: "")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        //ender
        
        
        
        
        
        super.viewDidLoad()
        
        let userEmail = PFUser.currentUser()?.objectForKey("email") as! String
        let nickname = PFUser.currentUser()?.objectForKey("username") as! String

        
        emalViewController.text = userEmail
        nickNameViewController.text = nickname
       
        
        
        
        
        
        //loading profile picture
        
        print("before we print the pic")
        
        if (PFUser.currentUser()?.objectForKey("profile_picture") != nil){
            print("there is a pic to be printed")
        
            let userImageFile:PFFile = (PFUser.currentUser()?.objectForKey("profile_picture") as? PFFile)!
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                
                
            if (imageData != nil){
                self.myPickerController.image = UIImage(data: imageData!)
                }
            })
        
        }else{
            self.myPickerController.image = UIImage(named: "Profile Picture@3x.png")
        }
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
         }

  

   @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    //image stuff
    
    
    @IBAction func selectProfilePicture(sender: UIButton) {
        
        let myPickerCtr = UIImagePickerController()
        myPickerCtr.delegate = self
        
        myPickerCtr.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerCtr, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        myPickerController.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
    //end image stuff

  
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    }
    
    
   
    


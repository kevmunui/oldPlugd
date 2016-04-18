
//
//  registerViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/16/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class registerViewController: UIViewController {
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var userReenterPasswordTextField: UITextField!
    
    @IBAction func joinUs(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func displayAlertmsg(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        //reachablity checker
        super.viewDidLoad()

        print("loading is happening")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filler(){
    
        let userEmail = userEmailTextField.text?.lowercaseString
        let userPassword = userPasswordTextField.text
        let userRepassword = userReenterPasswordTextField.text
        let nickName = nickNameTextField.text!.lowercaseString
        
        if (userPassword != userRepassword){
            self.displayAlertmsg("Passwords do not match!")
            return
        }
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || userRepassword!.isEmpty || nickName.isEmpty){
            self.displayAlertmsg("All fields are required!")
            return
        }
        
        if (userEmail!.rangeOfString("@berkeley.edu") == nil){
          self.displayAlertmsg( "We currently only support Berkeley email addresses. (____@berkeley.edu)")
            return
        }
        //store data
        let myUser: PFUser = PFUser()
        myUser.username = nickName
        myUser.password = userPassword
        myUser.email = userEmail
        myUser.signUpInBackgroundWithBlock{
            ( Bool succeeded, NSError ) -> Void in
            print("User successfully registered!", terminator: "")
            if (NSError != nil){
                let errorString = NSError!.userInfo["error"] as? NSString
                self.displayAlertmsg( "\(errorString!)")
                
            }else{
                  blogName1 = nickName
                  self.performSegueWithIdentifier("piclogIn", sender: nickName)
            }
        }
    }
   @IBAction  func registerButtonTapped(sender: UIButton) {
            self.filler()
    }

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

    

//
//  PasswordRecoveryViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/17/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class PasswordRecoveryViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recoveryButtonTap(sender: UIButton) {
        
        let userEmail = userEmailTextField.text
        
        if userEmail!.isEmpty{
            
            self.displayMessage("You must fill in the field")
            
        }else{
            
            
            PFUser.requestPasswordResetForEmailInBackground(userEmail!){
                (Bool succeeded, NSError) -> Void in
                if (succeeded){
                    let successMessage = "Recovery Email sent to \(userEmail)"
                    self.displayMessage(successMessage)
                    return
                    
                }
                
                if(NSError != nil){
                    let errorMessage : String = NSError!.userInfo["error"] as! String
                    self.displayMessage(errorMessage)
                }
                
            }
        }

        
        
    }
 
    @IBAction func cancelButtonTap(sender: UIButton) {
          self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
        
    func displayMessage(userMessage:String){
            
            let myAlert = UIAlertController(title: "Yo", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

//
//  loginViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/16/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class loginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here ;)", terminator: "")
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
   
    
    func displayAlertmsg(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func checker(sender: UIButton) {
        
        var userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        
        /*change username to lower case to help with clean log in*/
        userEmail = userEmail?.lowercaseString
        /*end function*/
        
        
        if userEmail!.isEmpty || userPassword!.isEmpty{
            
            self.displayAlertmsg("All fields are required")
            
            
            
        }else{
            
            
            
            
            PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!){
                (user, NSError) ->Void in
                
                
                if user != nil{
                    
                    //device connection
                    
                    let installation: PFInstallation = PFInstallation.currentInstallation()
                    installation.addUniqueObject("reload", forKey: "channels")
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackground()
                    
                    
                    //login is sucessfull
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.performSegueWithIdentifier("logintomain", sender: self)
                    
                } else{
                    
                    let errorString = NSError!.userInfo["error"] as? NSString
                    self.displayAlertmsg("\(errorString!)")
                    
                }
                
            }
        }
        
        

        
        
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

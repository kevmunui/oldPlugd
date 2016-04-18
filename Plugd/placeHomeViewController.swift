//
//  placeHomeViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/24/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class placeHomeViewController: UIViewController {

    override func viewDidLoad() {
        
        
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        
        NSUserDefaults.standardUserDefaults().setBool(false,forKey:"isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        PFUser.logOutInBackgroundWithBlock ({(NSError) ->Void in
            
            
//            let secondViewController:loginViewController = loginViewController()
//            
//            self.presentViewController(secondViewController, animated: true, completion: nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
           
            
           // self.performSegueWithIdentifier("loginView", sender: self)
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

}

//
//  eventViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/28/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class eventViewController: UIViewController {

    
    @IBOutlet weak var place_image: UIImageView!
    @IBOutlet weak var peoplegoing: UILabel!
  //  @IBOutlet weak var heatMap: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var textView: UITextView!
  //  @IBOutlet weak var peoplegoing: UILabel!
    @IBOutlet weak var address: UILabel!
   // @IBOutlet weak var partyAve: UILabel!
  //  @IBOutlet weak var heatMap: UILabel!
   // @IBOutlet weak var status: UILabel!
  //  @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var dateOfEvent: UILabel!
    
    //constants
    
    let myUser:PFUser =  PFUser.currentUser()!

    
    //variables
    var views: Float = 1
    var blogName = String()
    var isGoing:Bool = false
    var eveType:Bool = false
    var goer: Bool = false
    var swiTrrig = false
    var switter = false
    var bin = false
    var bin2 = false

    
    
   //start with this
    override func viewDidLoad() {
        //self.isGoing = isTriggered()
        
        //reachablity checker
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK", terminator: "")
        } else {
            print("Internet connection FAILED", terminator: "")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        //ender
        
        print(blogName)
        self.isTriggered()
        self.appendToViews(views)
        self.loadData()
        self.statusIS()
        self.staRequest()
        self.openChecker()
        self.checkerReq()
        self.checkerOpen()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func helperTrigger(trig : Bool) -> Bool{
        if(trig){
            self.isGoing = trig
           return self.isGoing
        }else{
            self.isGoing = trig
            return self.isGoing
        }
    
    
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    func statusIS(){
    
        if(self.isGoing){
         // self.status.text = "Going"
        }else{
         // self.status.text = "Not Going"
        
        }
    
    }
    
    func needRequest(request : String)->Bool{
        //open ->true
        if request.isEqual("open"){
            self.goer = true
            print("open", terminator: "")
            return self.eveType
        }
       //invite only ->false
        else{
            print("something else", terminator: "")
            self.goer = false
            return self.eveType
        }
    
    }

    func heatMapFunc(heatVar :Float){
        
        
        //view = heatMap
       // (view as! UIImageView!).image = UIImage(named: "page.png")
        
        
        
        switch true{
            
            
        case heatVar == 5/5 :
            //five STARS
            //self.heatMap = UIImage(named: "Star Ratings5@1x.png") as! UIImageView
            return
        case heatVar > 4/5 :
            //four STARS
           // self.heatMap = UIImage(named: "Star Ratings4@1x.png") as! UIImageView
            return
        case heatVar > 3/5 :
            //three STARS
            //self.heatMap = UIImage(named: "Star Ratings3@1x.png") as! UIImageView
            return
        case heatVar > 2/5 :
            //two STARS
            //self.heatMap = UIImage(named: "Star Ratings2@1x.png") as! UIImageView
            return
        case heatVar > 1/5 :
            //one STAR
            //self.heatMap = UIImage(named: "Star Ratings1@1x.png") as! UIImageView
            return
        case heatVar < 1/5:
            //NO STAR
            //self.heatMap = UIImage(named: "Star Ratings1@1x.png") as! UIImageView
            return
        default:
            return
        }

    
    
    }
    
    func appendToViews(views: Float){
    
    //fetch data from the db
    let finder = PFQuery(className:"placeName")
    finder.whereKey("objectId", equalTo:blogName )
    //get count column
    finder.findObjectsInBackgroundWithBlock({
        (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        //update the new count value
                        
                        var viewsN = object["views"] as? Float
                        let goingN = object["going"] as? Float
                        var popN = object["popularity"] as? Float
                        let req = object["inviteType"] as? String
                    
                        //view calculation
                        
                        viewsN = viewsN! + 1
                        
                        //popularity calculation
                        let s1 = viewsN! * 0.3
                        let s2 = goingN! * 0.7
                        popN = s1 + s2
                        
                        //send to function invite
                        self.needRequest(req!)
                        
                        //to send to func heat
                        let heat:Float = goingN!/viewsN!
                        //self.heatMapFunc(heat)
                        
                         //resave the new count value
                        object.setObject(viewsN!, forKey: "views")
                        object.setObject(popN!, forKey: "popularity")
                        object.saveInBackgroundWithBlock({(Bool succeeded, NSError) -> Void in})
                    }
                    
                }
                else {
                    print("\(error)", terminator: "")
                }
                
            }
            
        })
    
    }
    
    func displayAlertmsg(userMessage:String){
        
        let myAlert = UIAlertController(title: "Yo!", message: userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func loadData(){
        
        let finder = PFQuery(className:"placeName")
        finder.whereKey("objectId", equalTo:blogName )
        finder.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
    
                if let objects = objects as? [PFObject]?{
                for object in objects!{
                    let eventN = object["partyName"] as? String
                    let textV = object["Description"] as? String
                    let pricer = object["price"] as? String
                    let addressV = object["Location"] as? String
                    let peopG = (object["going"]! as? Float)!
                    let evenTyp = object["inviteType"] as? String
                    let eventDate = object["partyDate"] as? String
                    
                    
                    let dateFormatter:NSDateFormatter = NSDateFormatter()

                    
                    dateFormatter.dateFormat = "MM-dd-yy"
                    
                    
                    //show               
                    
                    if (object["place_picture"] as? PFFile != nil){
                        
                        
                        let userImageFile:PFFile = (object["place_picture"] as? PFFile)!
                        userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                            
                            
                            if (imageData != nil){
                                self.place_image.image = UIImage(data: imageData!)
                            }
                        })
                        
                    }else{
                        self.place_image.image = UIImage(named: "White_Background.png")
                    }
                    
                    
                    //image
                    
                    
                    
                    
                    

                    
                    self.price.text = pricer
                    self.dateOfEvent.text = eventDate!
                    self.eventType.text = evenTyp
                    self.eventName.text  = eventN
                    self.textView.text  = textV
                    self.address.text  = addressV
                    self.peoplegoing.text = "\(peopG)"
                    }
                
            }
            else {
                print("\(error)", terminator: "")
            }

            }
            
        })
    }
    
    @IBAction func reqbutton(sender: UIButton) {
        
        
       // var placeUser: PFObject = PFObject(className: "request")
        //check if field exisit to prevent multiple entries
        //check if the event is open or not
        if(!self.goer) {
            
            sender.enabled = false;
            
            
            if (!self.bin){
                self.goesRequest(self.switter)
            }else{
                displayAlertmsg("You already sent a request!")
                self.bin = false
            }
            
            
        }
        else{
            self.displayAlertmsg("This is an open event!")
        }
        
        
    }
    

    
    func checkerReq(){
    
        let query = PFQuery(className:"request")
        query.whereKey("user", equalTo: myUser)
        query.whereKey("event", equalTo:blogName )
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if (error == nil) {
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        
                        self.bin = (object["clicked"] as? Bool)!
                        
                    }
                    
                }
                
                
            }
            
        })
    
    
    
    
    }
    
    
    
    
    func staRequest(){
    
        
        let query = PFQuery(className:"request")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("event", equalTo:blogName )
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
        
            if (error == nil) {
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                         //self.eveType =  (object.objectForKey("decision") as? Bool)!
                    }
                    
                }
            
                
            }
            else {
                print("something wrong went on!", terminator: "")
            }
            
        
        })

    
       // return self.eveType
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func confirmButton(sender: UIButton) {
        
        //var trigger:Bool = isTriggered()
        
        if(self.goer){
            sender.enabled = false
            
            //if this is open
            print("thi is the \(self.bin2)", terminator: "")
            if (!self.bin2){
                print("we got here after the click \(self.bin2)", terminator: "")
                
                self.openChecker(self.bin2)
            }else{
                self.displayAlertmsg("You already said yes!")
            }
            
            
            
        }else{
            displayAlertmsg("Oh darn, this is an Invite only event, please request an invite")
        }
        
        
    }


    
    
    func openChecker(holder:Bool){
    
        if(!holder){
        
                self.displayAlertmsg("We hope you enjoy!")
                self.goes(holder)
                
                
                
                //update the going table
                let finder = PFQuery(className:"placeName")
                finder.whereKey("objectId", equalTo:self.blogName )
                //get count column
                finder.findObjectsInBackgroundWithBlock({
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil{
                        if let objects = objects as? [PFObject]?{
                            for object in objects!{
                                //update the new count value
                                
                                let viewsN = object["views"] as? Float
                                var goingN = object["going"] as? Float
                                var popN = object["popularity"] as? Float
                                //var objId = object["objectId"] as? String
                                
                                //going calculation
                                
                                goingN = goingN! + 1
                                
                                //popularity calculation
                                let s1 = viewsN! * 0.3
                                let s2 = goingN! * 0.7
                                popN = s1 + s2
                                
                                
                                //resave the new count value
                                object.setObject(goingN!, forKey: "going")
                                object.setObject(popN!, forKey: "popularity")
                                object.saveInBackgroundWithBlock({(Bool succeeded, NSError) -> Void in})
                                
                                
                                
                                
                                
                            }
                            
                        }
                        else {
                            print("\(error)", terminator: "")
                        }
                        
                    }
                    
                })
                





   
        
        
        }else{
            self.isGoing = true
            self.displayAlertmsg("You already said yes!")
            return
        }
        
    
    
    
    
    
    
    
    
    
    }
    
    
    func checkerOpen(){
    
        let query = PFQuery(className:"peopleGoing")
        query.whereKey("user", equalTo: myUser)
        query.whereKey("event", equalTo:blogName )
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if (error == nil) {
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        
                        self.bin2 = (object["isGoing"] as? Bool)!
                        print("this is a \(self.bin2)", terminator: "")
                        
                    }
                    
                }
                
                
            }
            
        })

    
    }
    
    
    
    
    
    
    
    
    func goes(go: Bool){
        let object:PFObject = PFObject(className: "peopleGoing")
        if(!go){
        object.setObject(myUser, forKey: "user")
        object.setObject(blogName, forKey: "event")
        object.setObject(true, forKey: "isGoing")
        object.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
            if(succeeded){
               print(" ", terminator: "")
            }else{
                print("\(NSError)", terminator: "")
                
            }
        
            }
        }else{
            displayAlertmsg("You already said yes!")
            return
        }
        
    
    }
    
    
    func goesRequest(go: Bool){
        let myUser:PFUser = PFUser.currentUser()!
        let object:PFObject = PFObject(className: "request")
        //self.isGoing = true
        if(!go){
            //check if it exists
            self.displayAlertmsg("Request sent!")

            object.setObject(myUser, forKey: "user")
            object.setObject(blogName, forKey: "event")
            object.setObject(self.eveType, forKey: "decision")
            object.setObject(true, forKey: "clicked")
            object.setObject(false, forKey: "trigg")
            object.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in
                if(succeeded){
                    print(" ", terminator: "")
                }else{
                    print("\(NSError)", terminator: "")
                    
                }
                
            }
        }else{
            displayAlertmsg("You already sent a request!")
            return
        }
        
        
    }
    
    
 //possible problem
    
    
    func openChecker(){
    
    
    
        let myUser:PFUser = PFUser.currentUser()!
        //CREATING  LOCAL BOOL VARIABLE
        
        let finder = PFQuery(className:"peopleGoing")
        finder.whereKey("event", equalTo:blogName )
        finder.whereKey("user", equalTo:myUser )
        finder.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        //maybe here
                        self.isGoing = object.objectForKey("isGoing")! as! Bool
                        
                        if(self.isGoing){
                           // self.status.text = "Going"
                            self.helperTrigger(self.isGoing)
                            return
                            
                        }else{
                           // self.status.text = "Not Going"
                            self.helperTrigger(self.isGoing)
                            return
                        }//end else
                        
                    }//end for
                    
                }//end of if
                
                
            }//end of second if
            else {
                print("\(error)", terminator: "")
            }//end for else
            
        })//end of finder
    
    
    }
    

    
    
    
    func isTriggered(){
        let myUser:PFUser = PFUser.currentUser()!
        //CREATING  LOCAL BOOL VARIABLE
        
        let finder = PFQuery(className:"request")
        finder.whereKey("event", equalTo:blogName )
        finder.whereKey("user", equalTo:myUser )
        //get count column
        finder.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        //maybe here
                        self.isGoing = object.objectForKey("decision")! as! Bool
                        
                        if(self.isGoing){
                            //self.status.text = "Going"
                            self.helperTrigger(self.isGoing)
                            return
 
                        }else{
                          // self.status.text = "Not Going"
                           self.helperTrigger(self.isGoing)
                           return
                        }//end else

                    }//end for
                    
                }//end of if
                
             
            }//end of second if
            else {
                print("\(error)", terminator: "")
            }//end for else
            
        })//end of finder
   // return self.isGoing
    
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



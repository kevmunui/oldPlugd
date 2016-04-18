//
//  requestsTableViewCell.swift
//  idksignin
//
//  Created by Kevin Ndiga on 8/1/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class requestsTableViewCell: UITableViewCell {
    
    //USER AND EVENT TYPE
    
    
    
    @IBOutlet weak var profile_picture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var partyName: UILabel!
    var trig: Bool = false // Whether or not invitation was accepted
    var cld: Bool = false  // Whether or not it has been clicked
    var event = String()
    var user = String()
    
    
    var compara1 = String()
    var compara2 = String()

    func objectType(user : String) -> PFObject{
        let userObject = PFObject()
        
    
     return userObject
    }
    
    @IBAction func acceptButton(sender: UIButton) {
        
        
        //if button accepted the the boolean of going changes to true
        
        if(!self.cld){
            self.trig = true
            self.cld = true
            
            changer(self.cld)
            sender.enabled = false

            
        }
        
        //push notificaton to inform the user
        //and kicked out from the list by changing the is clicked value to true
        

        
        
    }
    
    @IBAction func declineButton(sender: UIButton) {
        
        
        
        if(!self.cld){
            self.trig = false
            self.cld = true
            
            changer(self.trig)
            sender.enabled = false
            
        }
        
        //boolean remains pending
        //and kicked out from the list by changing the is clicked value to true
        
        
        
        
    }


    
    func changer(trig: Bool) {
     //open the query and update here
        //check if it has been clicked
        if(self.cld){
            //check for the decision
           if(trig){
                self.getandPut()

               } else {
            
                  self.put2(false)
    
              }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }
    
    func getandPut(){
        print("called getandPut()")
    
        //then the user end will change
        //change value in the isgoingpeople table
            
      
        
        //append to the peoplegoing table
        //put this info to the people table
        //put filters here
        self.put2(true)
        
        //end
        // no filters needed cause we are putting it for the first time

                        
                        
                        let findPlace: PFQuery = PFQuery(className: "_User")
                        //just change the bool value to delete the entry
                        findPlace.whereKey("email", equalTo: self.user)
                        findPlace.findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            if error == nil{
                                
                                
                                if let objects = objects as? [PFUser]{
                                    for object1 in objects{
                                        let object2:PFObject = PFObject(className: "peopleGoing")
                                        
                                        
                                        
                                        
                                        //update the going table
                                        let finder = PFQuery(className:"placeName")
                                        finder.whereKey("objectId", equalTo:self.event )
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
                                                        let partName = (object["partyName"] as? String)!
                                                        
                                                        
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
                                                        
                                        
                                                        
                                                        
                                                        
                                                        
                                                        //the push notification
                                                        
                                                        let pushQuery: PFQuery = PFInstallation.query()!
                                                        pushQuery.whereKey("user", equalTo: object1)
                                                        
                                                        let push:PFPush = PFPush()
                                                        push.setQuery(pushQuery)
        
                                                        push.setMessage("Request to attend \(partName) has been approved.")
                                                        push.sendPushInBackground()
                                                        
                                                        
                                                        //end of the push notification
                                                        
                                                    }
                                                    
                                                }
                                                else {
                                                    print("\(error)", terminator: "")
                                                }
                                                
                                            }
                                            
                                        })
                                       // saved data

                                        object2.setObject(object1 , forKey: "user")
                                        object2.setObject( self.event , forKey: "event")
                                        object2.setObject(true, forKey: "isGoing")
                                        object2.saveInBackgroundWithBlock {(Bool succeeded, NSError) -> Void in}
                                        
                                       
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        })
                        
        
    }
  
    func put2(deci: Bool){
        print("called put2(deci: ", deci, ")")
        let objecter = PFQuery(className:"request")
        let findPlace: PFQuery = PFQuery(className: "_User")
  
        //just change the bool value to delete the entry
        findPlace.whereKey("email", equalTo: self.user)
        
        findPlace.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        objecter.whereKey("user", equalTo: object)
                        
                    }
                    
                }
                
            }
            
        })
        
        objecter.whereKey("event", equalTo: event)
        //end of filters
        objecter.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        object.setObject(deci, forKey: "decision")
                        object.setObject(true, forKey: "trigg")
                        
                        object.saveInBackgroundWithBlock({(Bool succeeded, NSError) -> Void in})
                    }
                    
                }
                else {
                    print("\(error)", terminator: "")
                }
                
            }
            
        })
        
    }
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

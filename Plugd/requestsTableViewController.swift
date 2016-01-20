//
//  requestsTableViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 8/1/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse


class requestsTableViewController: UITableViewController {
    
    var placePageData:NSMutableArray = NSMutableArray()
    var email =  String()
    var username =  String()

    
    
    @IBAction func backbutton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
   @IBAction func loadData(){
        //get the requests that are false
        placePageData.removeAllObjects()
        
        let findPlaceData: PFQuery = PFQuery(className: "request")
        findPlaceData.whereKey("decision", equalTo: false)
        findPlaceData.whereKey("trigg", equalTo: false)

        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        self.placePageData.addObject(object)
                        
                    }
                    
                }
                
                
                
                
                let array:NSArray = self.placePageData.reverseObjectEnumerator().allObjects
                self.placePageData =  NSMutableArray(array: array)
                self.tableView.reloadData()
                
            }
            
        })
        //self.refreshControl!.endRefreshing()

    }

    override func viewDidLoad() {
        self.loadData()
        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refreshControl!)
        

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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return placePageData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: requestsTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! requestsTableViewCell

        let place:PFObject = self.placePageData.objectAtIndex(indexPath.row) as! PFObject
        
        //function calls USER EMAIL
        
         let users:PFObject = (place.objectForKey("user")as? PFObject)!
        
         let findPlaceData: PFQuery = PFQuery(className: "_User")
         findPlaceData.whereKey("objectId", equalTo: users.objectId!)
         findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    
                    for object in objects!{
                        self.email = (object.objectForKey("email") as? String)!
                        self.username = (object.objectForKey("username") as? String)!
                        
                        if (object.objectForKey("profile_picture") != nil){
                            let userImageFile:PFFile = (object.objectForKey("profile_picture") as? PFFile)!
                            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                
                                
                                if (imageData != nil){
                                    cell.profile_picture.image = UIImage(data: imageData!)
                                }
                            })
                       
                            
                        }
                        else{
                            /*just show a white background if no image is present*/
                            
                            cell.profile_picture.image = UIImage(contentsOfFile: "White_Background@1x.png")
                            
                        }
                       cell.profile_picture.layer.cornerRadius = cell.profile_picture.frame.size.width / 2
                        cell.profile_picture.clipsToBounds = true
                        cell.profile_picture.layer.borderColor = UIColor.purpleColor().CGColor
                        cell.profile_picture.layer.borderWidth = 3
                        

                        
                        cell.user = self.email
                        cell.emailField.text = self.email
                        cell.username.text = self.username
                    }
                    
                }
                
            }
            
         })

        
        //
        
        
        //getting the parties information
        let partyId: String = (place.objectForKey("event") as? String)!
        
        let placeDt: PFQuery = PFQuery(className: "placeName")
        placeDt.whereKey("objectId", equalTo: partyId)
        
        placeDt.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                      cell.partyName.text =  (object.objectForKey("partyName") as? String)!
                    }
                    
                }
                
            }
            
        })
        
        
        
        //
        
        //giving the events objectId

        cell.event = (place.objectForKey("event") as? String)!
        

        return cell
    }
    

    
    
   
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

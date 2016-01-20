//
//  myEventsTableViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/29/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class myEventsTableViewController: UITableViewController {
    
    
     @IBAction func backbutton(sender: UIButton) {
        
            self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    
    
    var placePageData:NSMutableArray = NSMutableArray()
    let myUser:PFUser =  PFUser.currentUser()!
    
    var stringer: String = ""
    
    let blogSegueIdentifier = "myEventSegue"
    
    
    @IBAction func loadData(){
        placePageData.removeAllObjects()
        
        let findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.whereKey("user", equalTo: myUser)
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

        
    }

    
    var refresherControl = UIRefreshControl()
    
    override func viewDidLoad() {
        self.loadData()
        
        
        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refreshControl!)
//        self.refreshControl!.endRefreshing()

        
        
        
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
        let cell: myEventsTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! myEventsTableViewCell
        
        let place:PFObject = self.placePageData.objectAtIndex(indexPath.row) as! PFObject
        if (place.objectForKey("icon_picture") as? PFFile != nil){
            
            let userImageFile:PFFile = (place.objectForKey("icon_picture") as? PFFile)!
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                
                if (imageData != nil){
                    cell.iconView.image = UIImage(data: imageData!)
                }
            })
            
        }else{
            cell.iconView.image = UIImage(named: "White_Background.png")
        }
        

        cell.placeName.text  = place.objectForKey("partyName") as? String
        cell.dateevent.text =  place.objectForKey("partyDate")as? String
        return cell
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == blogSegueIdentifier {
            if let EditEventViewController = segue.destinationViewController as? EditEventViewController{
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    stringer = placePageData[blogIndex].objectId!!
                    EditEventViewController.blogName = stringer
                }
            }
        }
    }
    
    
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



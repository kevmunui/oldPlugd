//
//  popularTableViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 8/4/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse

class popularTableViewController: UITableViewController {
    
    //map point dt
    struct pointPlace {
        
        var popularity = Float()
        var object = PFObject()
    }
    
    

    var mapDict = [Float: PFObject]()
    
    
    var placePageData:NSMutableArray = NSMutableArray()
    //let myUser:PFUser =  PFUser.currentUser()!
    
    
    
    var stringer: String = ""
    
    let blogSegueIdentifier = "myEventSegue"
    
    
     @IBAction func loadData(){
        placePageData.removeAllObjects()
        
        var point : [pointPlace] = []

        
        var findPlaceData: PFQuery = PFQuery(className: "placeName")
        findPlaceData.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                
                
                if let objects = objects as? [PFObject]?{
                    for object in objects!{
                        // map-->(((popularity),struct),....())
                        var popul = object["popularity"] as? Float
                        
                        let pnt = pointPlace(popularity: popul!, object: object)

                        
                        
                        var aPoint = pnt
                
                        //load the information in the dictionary with the key being the popularity
                        
                        //order the sarray
                       
                        aPoint.object = object
                        aPoint.popularity = popul!
                        
                      
                        point.append(aPoint)
                        
                        func sorterForFileIDASC(this:pointPlace, that:pointPlace) -> Bool {
                            return this.popularity > that.popularity
                        }
                     
                        point.sortInPlace(sorterForFileIDASC)
                        //append just ones in the list
                       
                }
            }
            
                
                
                
                for aPoint in point{
                    self.placePageData.addObject(aPoint.object)
                }

                self.tableView.reloadData()


            }
            
        })


    }

    
    
    
    
    
//  var refreshControl:UIRefreshControl!


    override func viewDidLoad() {
        self.loadData()
        super.viewDidLoad()
      
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refreshControl!)
//        self.refreshControl!.endRefreshing()

        
        
        
        //reachablity checker
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
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
        
     
        
        
        
        
        let cell: popularTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! popularTableViewCell
        
        let place:PFObject = self.placePageData.objectAtIndex(indexPath.row) as! PFObject
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yy"
       
        cell.time.text = dateFormatter.stringFromDate(place.createdAt!)
        /*hide to see the results uncomment soon*/
         cell.event.text  = place.objectForKey("partyName") as? String
        //let num = indexPath.row + 1
        //cell.numb.text = ("\(num)")
        //cell.eventType.text = place.objectForKey("inviteType") as? String
        
        cell.eventDay.text = place.objectForKey("partyDate") as? String

        cell.price.text = place.objectForKey("price") as? String
        cell.host.text = place.objectForKey("host") as? String
        
        if (place.objectForKey("icon_picture") as? PFFile != nil){
            
            let userImageFile:PFFile = (place.objectForKey("icon_picture") as? PFFile)!
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                
                if (imageData != nil){
                    cell.iconView.image = UIImage(data: imageData!)
                }
            })
            
        }else{
            print("here")
            cell.iconView.image = UIImage(named: "White_Background.png")
        }
        
        
        
        
        
        return cell

    }
    
    
    
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == blogSegueIdentifier {
            if let eventViewController = segue.destinationViewController as? eventViewController{
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    stringer = placePageData[blogIndex].objectId!!
                    eventViewController.blogName = stringer
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

}

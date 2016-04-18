//
//  ViewController.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/16/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    struct pointPlace {
        
        var popularity = Float()
        var object = PFObject()
    }
    
   
    var coords: CLLocationCoordinate2D?
    
 @IBOutlet weak var mapView: MKMapView!

    
    
  @IBAction func getPlaces() {
    
    self.mapme()

    
    var point : [pointPlace] = [ ]

            //map point dt
    
                var findPlaceData: PFQuery = PFQuery(className: "placeName")
                findPlaceData.findObjectsInBackgroundWithBlock({
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil{

                        
                        if let objects = objects as? [PFObject]?{
                            for object in objects!{
                                // map-->(((popularity),struct),....())
                                var popul = object["popularity"] as? Float
                                
                                var pnt = pointPlace(popularity: popul!, object: object)
                                
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
                            self.getter(point)

                        }
                        
                        
                        
                    }
                    
                })
                

    
    
    
    }
    
    //getting the points to plot
    func getter (place :[pointPlace] ){
        
        var pnt : [pointPlace] = [ ]
        
        for pl in place{
            pnt.append(pl)

        }
        
        if place.count < 5{
            //print out everything
            //get items and pass them into the plotter
            
            for bpoint in place{
              self.mapPlotter(bpoint.object)
            
            }
        
        }else{
            var holder = 0
            //vvar holder : [pointPlace] = []
            holder = place.count

            while( holder != 0 ){
            if holder > 5{
               holder = holder - 1
               //place.removeLast()
               pnt.removeLast()

            }else{
                for bpoint in pnt{
                    
                    self.mapPlotter(bpoint.object)
                    
                }
                holder = holder - 1

            }
            //get items and pass them into the plotter
            //print only the top five
        }

    }
    }
    //annotation plotter
    
    func mapPlotter(point: PFObject){
        
        
        //convert location into co-odinates
        let geoCoder = CLGeocoder()
        let loc = point["Location"] as? String
        let parName = point["partyName"] as? String
        
        
        let addressString = "\(loc!)"
        geoCoder.geocodeAddressString(addressString)  {(placemarks, error) -> Void in
            
            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                
//                let placemark = placemarks?[0]
//                let location = placemark!.location
//                self.coords = location!.coordinate
//                let dropPin = MKPointAnnotation()
//                dropPin.coordinate = self.coords!
//                dropPin.title = parName
//                self.mapView.addAnnotation(dropPin)
              
                
                
                let placemark = placemarks?[0]
                let location = placemark!.location
                self.coords = location!.coordinate
            
                let dropPin = CustomPointAnnotation()
                dropPin.coordinate = self.coords!
                dropPin.title = parName
                dropPin.imageName = UIImage(named: "Pin@3x.png")
                self.mapView.addAnnotation(dropPin)
                
                
                //end
                
                
            }
        }
        
        
        //ender
        
        // Drop a pin
        if self.coords == nil{
        
        }
    
    }
    
    
    
    
    
//    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if !(annotation is CustomPointAnnotation) {
//            return nil
//        }
//        
//        let reuseId = "test"
//        
//        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
//        if anView == nil {
//            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            anView!.canShowCallout = true
//        }
//        else {
//            anView!.annotation = annotation
//        }
//        
//        //Set annotation-specific properties **AFTER**
//        //the view is dequeued or created...
//        
//        let cpa = annotation as! CustomPointAnnotation
//        anView!.image = UIImage(named:cpa.imageName)
//        
//        return anView
//    }
    
  
    
    
    
    
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    var placePageData:NSMutableArray = NSMutableArray()
    var placePageFive:NSMutableData = NSMutableData()

    
    func mapme(){
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    
    override func viewDidLoad() {
        self.getPlaces()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true;
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        

        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
    let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if(!isUserLoggedIn){
            self.performSegueWithIdentifier("logintoView", sender: self)
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        myPosition = newLocation.coordinate
        
        _ = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.009, 0.009)
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        
        locationManager.stopUpdatingLocation()
     
    }
    

    
 

    
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: UIImage!
}


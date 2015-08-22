//
//  MapViewController.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var radius: CLLocationDistance = 300
    
    var locationManager = CLLocationManager()
    
    var pinsLocations = Array<MKPointAnnotation>()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true

        locationManager.requestAlwaysAuthorization()
        // Do any additional setup after loading the view.
    }
    
    
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                return nil
                
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.canBecomeFirstResponder()
                pinView!.pinColor = .Purple
                
                
                annotation.coordinate
                
                
                
                let roleButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                
                roleButton.addTarget(self, action: "selectRole:", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                roleButton.frame.size.width = 44
                roleButton.frame.size.height = 44
                roleButton.setImage(UIImage(named: "main_seta"), forState: .Normal)
                
                
                
                //var rightButton :UIButton = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
                
                
                
                pinView!.rightCalloutAccessoryView = roleButton
                
                //                    var icon = UIImageView(image: UIImage(named: "teste.png"))
                //                    pinView!.leftCalloutAccessoryView = icon
                
            }
            else {
                pinView!.annotation = annotation
            }
            
            
            return pinView
    }
    

    
    override func viewWillAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        
//        var annView = view.annotation
//        
//        
//        let nextViewController = TransitionManager.creatView("PartidaTableViewController") as! PartidaTableViewController
//        var event = Event()
//        
//        
//        event.localizacao = Localizacao()
//        event.localizacao?.name = annView.title
//        
//        event.localizacao?.latitude = Float(annView.coordinate.latitude)
//        event.localizacao?.longitude = Float(annView.coordinate.longitude)
//        
//        nextViewController.event = event
//        
//        nextViewController.location = annView.coordinate
//        
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        
        
        //        annotation *annView = view.annotation;
        //        detailedViewOfList *detailView = [[detailedViewOfList alloc]init];
        //        detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        detailView.address = annView.address;
        //        detailView.phoneNumber = annView.phonenumber;
        //        [self presentModalViewController:detailView animated:YES];
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            //showActivity()
            
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.AuthorizedAlways:
                shouldIAllow = true
            default:
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            
            if (shouldIAllow == true) {
                // Start location services
                locationManager.startUpdatingLocation()
            }
            
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        locationManager.stopUpdatingLocation()
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
        
        mapView.setRegion(region, animated: true)
        
        mapView.userLocation.title = "user"//nomeUser
        
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

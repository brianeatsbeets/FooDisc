//
//  CoursesViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/24/22.
//

import UIKit
import MapKit

class CoursesViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    //var courses : [Course] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocationServices()
        zoomToCurrentLocation()
    }
    
    // MARK: Location functions //

    // Initialize location services
    func initializeLocationServices() {
        locationManager.delegate = self
        
        //TODO: only request if user hasn't already responded to request
        //TODO: display non-consequential location permissions alert request prior to real request
        //TODO: handle denied location permissions
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // This is the default value
        locationManager.distanceFilter = kCLDistanceFilterNone // This is the default value
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    // Respond to updated user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
        }
    }

    // Respond to changed location authorization permissions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("User changed location authorization permissions to \(status).")
    }

    // Respond to inability to get user location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location: \(error).")
    }
    
    // Zoom the map to the user's general location
    func zoomToCurrentLocation() {
        
    }
}


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
    var currentLocation = CLLocation()
    
    // Zoom the course map once user location is determined
    var initialLocation = CLLocation() {
        didSet {
            zoomToLocation(initialLocation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocationServices()
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get initial location and zoom to it
        if locations.count == 1 {
            initialLocation = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        }
        
        // Set currentLocation
        if let location = locations.last {
            currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print("Updated Location: \(currentLocation.coordinate)")
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
    
    // Zoom the map to a given location
    // TODO: figure out why this is being called every time location is updated. look into the didUpdateLocations locations array
    func zoomToLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        print("Zoomed location: \(location.coordinate)")
    }
}


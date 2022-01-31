//
//  CoursesMapViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/24/22.
//

import UIKit
import MapKit

class CoursesMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    // Reload annotations when new data is present
    var courses : [Course] = [] {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(courses)
        }
    }
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var receivedInitialLocation = false
    
    // Zoom the course map once user location is determined
    var initialLocation = CLLocation() {
        didSet {
            zoomToLocation(initialLocation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        initializeLocationServices()
        mapView.addAnnotations(courses)
    }
    
    // MARK: Location functions

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
        
        // Set currentLocation
        if let location = locations.last {
            
            // Get initial location and zoom to it
            if !receivedInitialLocation {
                receivedInitialLocation = true
                initialLocation = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            }
            
            currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    // Respond to changed location authorization permissions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("User changed location authorization permissions to \(status).")
    }

    // Respond to inability to get user location
    // TODO: alert user and describe potential loss of functionality
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location: \(error).")
    }
    
    // Zoom the map to a given location
    func zoomToLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: Annotation functions
    
    // Create a visible annotation for a course
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? Course else {
            return nil
        }
        
        let identifier = "course"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
}


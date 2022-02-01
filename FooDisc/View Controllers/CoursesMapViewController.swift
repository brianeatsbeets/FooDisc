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
    
    var courses : [Course] = [] {
        didSet {
            // Reload annotations when new course data is present
            updateUserToCourseDistances()
        }
    }
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var receivedInitialLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        initializeLocationServices()
        
        // Register CourseView class as the default annotation view reuse identifier
        mapView.register(CourseView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotations(courses)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update course distances when user navigates to this view in case user location has changed
        updateUserToCourseDistances()
    }
    
    // MARK: Location functions

    // Initialize location services
    func initializeLocationServices() {
        locationManager.delegate = self
        
        //TODO: only request if user hasn't already responded to request
        //TODO: display non-consequential location permissions alert request prior to real request
        //TODO: handle denied location permissions and communicate potential loss of functionality
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    // Respond to updated user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get most recent location
        if let location = locations.last {
            
            // Set currentLocation
            currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            // Check if this is the first location we've received
            if !receivedInitialLocation {
                receivedInitialLocation = true
                
                // If so, perform a one-time zoom to the user's local area and refresh annotations
                let initialLocation = currentLocation
                zoomToLocation(initialLocation)
                updateUserToCourseDistances()
            }
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
    
    // Update course distances based on user's current location
    func updateUserToCourseDistances() {
        for course in courses {
            
            // Calculate the distance from the user to a course in miles
            let courseLocation = CLLocation(latitude: course.coordinate.latitude, longitude: course.coordinate.longitude)
            let distanceInMiles = currentLocation.distance(from: courseLocation) / 1609
            
            course.distanceFromUser = round(distanceInMiles * 10) / 10.0 // Round to tenths place
        }
        
        // Refresh the annotations to display the updated distances
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(courses)
    }
    
    // MARK: Annotation functions
    // Need to verify - is this mapView implementation (moreso the whole dequeue process) actually needed,
    // or is it replaced by the whole 'willSet' shenanigans in the CourseView?
    
//    // Create a visible annotation for a course
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        // Make sure we're dealing with a Course object
//        guard let annotation = annotation as? Course else {
//            return nil
//        }
//        
//        let identifier = "course"
//        var view: MKAnnotationView
//        
//        // Check for a reusable dequeued view
//        // If one is available, use it; if not, create one
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//
//        return view
//    }
}


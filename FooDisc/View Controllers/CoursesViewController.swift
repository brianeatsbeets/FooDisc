//
//  CoursesViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/24/22.
//

import UIKit
import MapKit

class CoursesViewController: UIViewController {

    @IBOutlet var viewSelector: UISegmentedControl!
    
    var courses : [Course] = []
    
    // Lazily instantiate child view controllers
    private lazy var coursesMapViewController: CoursesMapViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesMapViewController") as! CoursesMapViewController
        viewController.courses = courses
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var coursesListTableViewController: CoursesListTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesListTableViewController") as! CoursesListTableViewController
        viewController.courses = courses
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSegmentedControl()
        readJSONFile()
        updateView()
    }
    
    func initializeSegmentedControl() {
        viewSelector.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    func readJSONFile() {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("courses.geojson")

            let courseData = try Data(contentsOf: fileURL)
            
            // Attempt to decode geoJSON data and create an array of non-nil MKGeoJSONFeature objects
            let features = try MKGeoJSONDecoder().decode(courseData).compactMap { $0 as? MKGeoJSONFeature }

            // Create an array of viable Place objects from the above array
            let validCourses = features.compactMap(Course.init)
            
            // Append viable Place objects to places array
            courses.append(contentsOf: validCourses)
            
            //let foo = try JSONDecoder().decode(Course.self, from: data)
            //print(foo)
        } catch {
            print(error)
        }
    }
    
    func updateView() {
        if viewSelector.selectedSegmentIndex == 0 {
            remove(asChildViewController: coursesListTableViewController)
            add(asChildViewController: coursesMapViewController)
        } else {
            remove(asChildViewController: coursesMapViewController)
            add(asChildViewController: coursesListTableViewController)
        }
    }
    
    // Add the child view to the superview
    func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
    }
    
    // Remove the child view to the superview
    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    
}


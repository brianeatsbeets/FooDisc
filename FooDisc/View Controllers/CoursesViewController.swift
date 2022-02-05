//
//  CoursesViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/24/22.
//

import UIKit

// Protocol to allow other view controllers to update the courses array managed in the CoursesViewController class
protocol CoursesDelegate: AnyObject {
    func updateCoursesArray(courses: [Course])
}

// This class/view controller serves as the container view controller for CoursesMapViewController and CoursesListTableViewController
class CoursesViewController: UIViewController, CoursesDelegate {

    // MARK: Variable declarations
    
    @IBOutlet var viewSelector: UISegmentedControl!
    var courses : [Course] = [] {
        
        // Update map and table view course arrays when the main course array is updated
        didSet {
            coursesMapViewController.courses = courses
            coursesListTableViewController.courses = courses
        }
    }
    
    // Lazily instantiate child view controllers
    lazy var coursesMapViewController: CoursesMapViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesMapViewController") as! CoursesMapViewController
        viewController.containerViewController = self
        self.add(asChildViewController: viewController)
        return viewController
    }()
    lazy var coursesListTableViewController: CoursesListTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesListTableViewController") as! CoursesListTableViewController
        viewController.containerViewController = self
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    // MARK: CoursesDelegate delegate functions
    
    // Delegate method to update courses from other view controllers
    func updateCoursesArray(courses: [Course]) {
        self.courses = courses
    }
    
    // MARK: Class functions
    
    // Load up data and views to display
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = fetchCourseData()
        initializeSegmentedControl()
        updateView()
    }
    
    // Set up segmented control for user interaction
    func initializeSegmentedControl() {
        viewSelector.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    // @objc function to respond to segmented control selection change
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    // Refresh data after adding new course
    @IBAction func unwindToCoursesViewController(segue: UIStoryboardSegue) {
        courses = fetchCourseData()
    }
    
    // MARK: Child view controller management
    
    // Display the appropriate child view controller
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


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
        print("initialized coursesmapviewcontroller")
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
        
        loadData()
        initializeSegmentedControl()
        updateView()
    }
    
    func initializeSegmentedControl() {
        viewSelector.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        if let savedCourses = defaults.object(forKey: "Courses") as? [Course] {
            courses = savedCourses
            print("Successfully loaded courses from UserDefaults")
        } else {
            print("Error loading courses from UserDefaults")
        }
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
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


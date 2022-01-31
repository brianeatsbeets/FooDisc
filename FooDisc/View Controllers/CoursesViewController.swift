//
//  CoursesViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/24/22.
//

import UIKit

class CoursesViewController: UIViewController {

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
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    lazy var coursesListTableViewController: CoursesListTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesListTableViewController") as! CoursesListTableViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    // Load up data and views to display
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        initializeSegmentedControl()
        updateView()
    }
    
    // Load course data from User Defaults
    func loadData() {
        let defaults = UserDefaults.standard
        
        // Fetch courses array
        if let data = defaults.data(forKey: "Courses") {
            do {
                let decoder = JSONDecoder()
                courses = try decoder.decode([Course].self, from: data)
            } catch {
                print("Failed to decode courses: \(error)")
            }
        }
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
        loadData()
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


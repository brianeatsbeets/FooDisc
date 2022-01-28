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
    
    var courses : [Course] = [] {
        didSet {
            coursesMapViewController.courses = courses
            coursesListTableViewController.courses = courses
            print("courses updated in child view controllers")
        }
    }
    
    // Lazily instantiate child view controllers
    private lazy var coursesMapViewController: CoursesMapViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesMapViewController") as! CoursesMapViewController
        //viewController.courses = courses
        self.add(asChildViewController: viewController)
        print("initialized coursesmapviewcontroller")
        return viewController
    }()
    
    private lazy var coursesListTableViewController: CoursesListTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CoursesListTableViewController") as! CoursesListTableViewController
        //viewController.courses = courses
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
        
        // Read/Get Data
        if let data = defaults.data(forKey: "Courses") {
            print("flag 1")
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                courses = try decoder.decode([Course].self, from: data)
                print("Successfully decoded courses")

            } catch {
                print("Unable to Decode Courses (\(error))")
            }
        } else {
            print("flag 2")
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
    
    // Refresh data after adding new course
    // TODO: refresh map annotations
    @IBAction func unwindToCoursesViewController(segue: UIStoryboardSegue) {
        loadData()
        coursesListTableViewController.tableView.reloadData()
    }
}


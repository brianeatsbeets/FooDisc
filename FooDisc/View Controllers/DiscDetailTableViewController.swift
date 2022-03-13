//
//  DiscDetailTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 3/9/22.
//

import UIKit

// TODO: have camera capture square image instead of rectangular
// TODO: un-require some text fields and make the properties optional
// TODO: add next button/toolbar on all textfield keyboards
// TODO: troubleshoot the constraint warnings on the UIToolbars
// TODO: verify that the user wants to clear the disc picture via an alert
// TODO: only display decimal values if the Double value is not a whole number
class DiscDetailTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var discColorView: UIView!
    @IBOutlet var discImageView: UIImageView!
    @IBOutlet var typeSegmentedControl: UISegmentedControl!
    @IBOutlet var manufacturerTextField: UITextField!
    @IBOutlet var plasticTextField: UITextField!
    @IBOutlet var speedTextField: UITextField!
    @IBOutlet var glideTextField: UITextField!
    @IBOutlet var turnTextField: UITextField!
    @IBOutlet var fadeTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var conditionSegmentedControl: UISegmentedControl!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var inBagSegmentedControl: UISegmentedControl!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var disc: Disc?
    
    var requiredTextFields = [UITextField]()
    var polarityToolbarTextFields = [UITextField]()
    var activeTextField = UITextField()
    
    let colorPicker = UIColorPickerViewController()
    
    // MARK: Class functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UIColorPicker
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        
        // Compile UITextField arrays for bulk manipulation
        requiredTextFields = [nameTextField, manufacturerTextField, plasticTextField, speedTextField, glideTextField, turnTextField, fadeTextField, weightTextField]
        polarityToolbarTextFields = [speedTextField, glideTextField, turnTextField, fadeTextField]
        
        initializeTextFieldToolbars()
        
        updateView()
        updateSaveButtonState()
    }
    
    // Create, configure, and assign UIToolbars
    func initializeTextFieldToolbars() {
        let polarityDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolbarDoneButtonTapped))
        let polarityButton = UIBarButtonItem(title: "+/-", style: .plain, target: self, action: #selector(toolbarPolarityButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let polarityToolbar = UIToolbar()
        polarityToolbar.items = [polarityButton, flexSpace, polarityDoneButton]
        polarityToolbar.sizeToFit()
        
        for textField in polarityToolbarTextFields {
            textField.inputAccessoryView = polarityToolbar
            textField.delegate = self
        }
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolbarDoneButtonTapped))
        
        let doneToolbar = UIToolbar()
        doneToolbar.items = [flexSpace, doneButton]
        doneToolbar.sizeToFit()
        
        weightTextField.inputAccessoryView = doneToolbar
    }
    
    // Toggle save button interatability based on textField validation
    func updateSaveButtonState() {
        var shouldEnableSaveButton = true
        for textField in requiredTextFields {
            if textField.text!.isEmpty {
                shouldEnableSaveButton = false
            }
        }
        
        saveButton.isEnabled = shouldEnableSaveButton
        
    }
    
    // Load disc data if editing a disc
    func updateView() {
        if let disc = disc {
            navigationItem.title = "Edit Disc"
            updateDiscColor()
            updateDiscImage()
            nameTextField.text = disc.name
            typeSegmentedControl.selectedSegmentIndex = disc.type.getIndex()
            manufacturerTextField.text = disc.manufacturer
            plasticTextField.text = disc.plastic
            speedTextField.text = String(disc.speed)
            glideTextField.text = String(disc.glide)
            turnTextField.text = String(disc.turn)
            fadeTextField.text = String(disc.fade)
            weightTextField.text = String(disc.weightInGrams)
            conditionSegmentedControl.selectedSegmentIndex = disc.condition.getIndex()
            notesTextField.text = disc.notes
            inBagSegmentedControl.selectedSegmentIndex = {
                if disc.inBag {
                    return 0
                } else {
                    return 1
                }
            }()
        }
    }
    
    // Load disc color and set UIColorPicker default color
    func updateDiscColor() {
        if let discColor = disc?.color {
            discColorView.backgroundColor = discColor
            colorPicker.selectedColor = discColor
        } else {
            discColorView.backgroundColor = .white
            colorPicker.selectedColor = .white
        }
    }
    
    // Load disc image
    func updateDiscImage() {
        if let imageData = disc?.imageData,
            let image = UIImage(data: imageData) {
            discImageView.image = image
        } else {
            discImageView.image = nil
        }
    }
    
    // Create and present UIImagePicker for disc image selection
    @IBAction func updateDiscImageButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Clear the disc image
    @IBAction func clearDiscImageButtonTapped(_ sender: Any) {
        discImageView.image = nil
    }
    
    // Present the UIColorPicker for disc color selection
    @IBAction func updateDiscColorButtonTapped(_ sender: Any) {
        present(colorPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerController delegate methods
    
    // Set the disc image to the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        discImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss the UIImagePicker when cancel is pressed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIColorPickerViewController delegate methods
    
    // Set the disc color to the selected color upon exit
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.discColorView.backgroundColor = viewController.selectedColor
    }
    
//    // Set the disc color to the selected color - UIColorPicker covers the majority of the view so these changes to the discColorView will not be visible to the user
//    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
//        self.discColorView.backgroundColor = viewController.selectedColor
//    }
    
    // MARK: TextField functions
    
    // TODO: use this implementation instead of listeners in other areas of FooDisc that require validation
    // Update the save button interactability based on textField validation
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Dismiss keyboard when done key is pressed
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    // Dismiss keyboard when toolbar done button is tapped
    @objc func toolbarDoneButtonTapped() {
        view.endEditing(true)
    }
    
    // Toggle polarity of textField when toolbar polarity button is tapped
    @objc func toolbarPolarityButtonTapped() {
        let textField = activeTextField
        if textField.text?.first == "-" {
            let substring = String(textField.text!.suffix(textField.text!.count - 1))
            textField.text = substring
        } else {
            textField.text = "-" + textField.text!
        }
    }
    
    // MARK: UITextFieldDelegate delegate methods
    
    // Set the active textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    // MARK: Navigation
    
    // Edit/create and save the disc object, then navigate back to DiscTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        if disc != nil {
            disc!.name = nameTextField.text!
            disc!.color = discColorView.backgroundColor!
            disc!.imageData = discImageView.image?.jpegData(compressionQuality: 0.9) ?? nil
            disc!.type = DiscType.allCases[typeSegmentedControl.selectedSegmentIndex]
            disc!.manufacturer = manufacturerTextField.text!
            disc!.plastic = plasticTextField.text!
            disc!.speed = Double(speedTextField.text!) ?? 0
            disc!.glide = Double(glideTextField.text!) ?? 0
            disc!.turn = Double(turnTextField.text!) ?? 0
            disc!.fade = Double(fadeTextField.text!) ?? 0
            disc!.weightInGrams = Double(weightTextField.text!) ?? 0
            disc!.condition = Condition.allCases[conditionSegmentedControl.selectedSegmentIndex]
            disc!.notes = notesTextField.text ?? ""
            disc!.inBag = inBagSegmentedControl.selectedSegmentIndex == 0
        } else {
            let name = nameTextField.text!
            let color = discColorView.backgroundColor!
            let imageData = discImageView.image?.jpegData(compressionQuality: 0.9) ?? nil
            let type = DiscType.allCases[typeSegmentedControl.selectedSegmentIndex]
            let manufacturer = manufacturerTextField.text!
            let plastic = plasticTextField.text!
            let speed = Double(speedTextField.text!) ?? 0
            let glide = Double(glideTextField.text!) ?? 0
            let turn = Double(turnTextField.text!) ?? 0
            let fade = Double(fadeTextField.text!) ?? 0
            let weight = Double(weightTextField.text!) ?? 0
            let condition = Condition.allCases[conditionSegmentedControl.selectedSegmentIndex]
            let notes = notesTextField.text ?? ""
            let inBag = inBagSegmentedControl.selectedSegmentIndex == 0
            
            disc = Disc(name: name, color: color, imageData: imageData, type: type, manufacturer: manufacturer, plastic: plastic, weightInGrams: weight, speed: speed, glide: glide, turn: turn, fade: fade, condition: condition, notes: notes, inBag: inBag)
        }
        
        
    }
}

//
//  ViewController.swift
//  FoodExpireDateTracker
//
//  Created by Fang Yang on 30/1/18.
//  Copyright © 2018 Yang Fang. All rights reserved.
//

import UIKit
import os.log

class FoodViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var food: Food?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddFoodMode = presentingViewController is UINavigationController
        if isPresentingInAddFoodMode{
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationControll = navigationController{
            owningNavigationControll.popViewController(animated: true)
        }else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        dateTextField.delegate = self
        
        if let food = food{
            nameTextField.text = food.name
            dateTextField.text = food.date
            photoImageView.image = food.photo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        nameTextField.delegate = self
        dateTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let photo = photoImageView.image
        
        food = Food(name: name, date: date, photo: photo)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK UITextFieldDelegage
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if textField == nameTextField {
            navigationItem.title = textField.text
        }
    }

    @IBAction func selectPhotoFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState(){
        let nameText = nameTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty && !dateText.isEmpty
    }
}


//
//  AddNewNoteController.swift
//  DeathNote
//
//  Created by Steve Vovchyna on 12.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

protocol SaveNewNoteDelegate {
    func userSavedNewNote(newNote: DeathNote)
}

class AddNewNoteConroller : UIViewController {
    
    var delegate : SaveNewNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .dark
        newNameInput.addTarget(self, action: #selector(fieldDidChange(_:)), for: .editingChanged)
        doneButton.isEnabled = false
        
        datePicker.minimumDate = Date.init(timeIntervalSinceNow: 0)
        
        descriptionInput.layer.borderColor = UIColor.black.cgColor
        descriptionInput.layer.borderWidth = 1.0
    }
    
    @IBOutlet weak var newNameInput: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var descriptionInput: UITextView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    
    @IBAction func dataCollected(_ sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        let name = newNameInput?.text ?? "Bob"
        let description = descriptionInput?.text ?? "No description"
        let newDeathNote = DeathNote(name: name, date: date, description: description)
        delegate?.userSavedNewNote(newNote: newDeathNote)
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var getBack: UINavigationItem!
    
    @objc func fieldDidChange(_ newNameField: UITextField) {
        if newNameInput.text!.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
}

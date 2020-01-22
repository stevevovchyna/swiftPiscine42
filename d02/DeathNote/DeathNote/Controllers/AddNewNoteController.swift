//
//  AddNewNoteControlerViewController.swift
//  DeathNote
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import Foundation
import UIKit

protocol SaveNewNoteDelegate {
    func userSavedNewNote(newNote: DeathNote)
}

class AddNewNoteConroller : UIViewController {
    
    var delegate : SaveNewNoteDelegate?
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var newNameInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        newNameInput.addTarget(self, action: #selector(fieldDidChange(_:)), for: .editingChanged)
        doneButton.isEnabled = false
        datePicker.minimumDate = Date.init(timeIntervalSinceNow: 0)
        descriptionInput.layer.borderColor = UIColor.black.cgColor
        descriptionInput.layer.borderWidth = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @IBAction func dataCollected(_ sender: UIBarButtonItem) {
        let date = dateFormatter.string(from: datePicker.date)
        let name = newNameInput?.text ?? "Bob"
        let description = descriptionInput?.text ?? "No description"
        let newDeathNote = DeathNote(name: name, date: date, description: description)
        delegate?.userSavedNewNote(newNote: newDeathNote)
        navigationController?.popViewController(animated: true)
    }

    @objc func fieldDidChange(_ newNameField: UITextField) {
        if newNameInput.text!.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
}

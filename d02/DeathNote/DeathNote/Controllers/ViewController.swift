//
//  ViewController.swift
//  DeathNote
//
//  Created by Stepan VOVCHYNA on 12/21/19.
//  Copyright © 2019 Stepan VOVCHYNA. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, SaveNewNoteDelegate {
    
    var deathNotesArray : [DeathNote] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newNoteCreated" {
            let destinationVC = segue.destination as! AddNewNoteConroller
            destinationVC.delegate = self
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    //MARK:- table view methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! CustomTableViewCell
        cell.dateLabel?.text = deathNotesArray[indexPath.row].date
        cell.nameLabel?.text = deathNotesArray[indexPath.row].name
        cell.descriptionLabel?.text = deathNotesArray[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deathNotesArray.count
    }
}

extension ViewController {
    func userSavedNewNote(newNote: DeathNote) {
        deathNotesArray.append(newNote)
        tableView.reloadData()
    }
}

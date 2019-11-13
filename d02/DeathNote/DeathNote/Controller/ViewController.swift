//
//  ViewController.swift
//  DeathNote
//
//  Created by Steve Vovchyna on 12.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController, SaveNewNoteDelegate {
    
    var deathNotesArray : [DeathNote] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - table view methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toKillCell", for: indexPath) as! MyTableViewCell
        
        cell.dateLabel?.text = deathNotesArray[indexPath.row].date
        cell.nameLabel?.text = deathNotesArray[indexPath.row].name
        cell.descriptionLabel?.text = deathNotesArray[indexPath.row].description
        cell.descriptionLabel.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deathNotesArray.count
    }
    
    func userSavedNewNote(newNote: DeathNote) {
        deathNotesArray.append(newNote)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newNoteCreated" {
            let destinationVC = segue.destination as! AddNewNoteConroller
            destinationVC.delegate = self
        }
    }

}


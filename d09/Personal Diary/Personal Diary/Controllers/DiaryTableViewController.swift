//
//  DiaryTableViewController.swift
//  Personal Diary
//
//  Created by Steve Vovchyna on 25.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import svovchyn2019

class DiaryTableViewController: UITableViewController {
    
    let articleManager = ArticleManager()
    let dateFormatter = DateFormatter()
    
    var allArticles : [Article] = []
    var picturesForArticles : [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allArticles = articleManager.getAllArticles()
        picturesForArticles = transformPicturesInArticleArray(array: allArticles)
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "articleCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        articleManager.save()
        allArticles = articleManager.getAllArticles()
        picturesForArticles = transformPicturesInArticleArray(array: allArticles)
        tableView.reloadData()
        
    }
    
    func transformPicturesInArticleArray(array: [Article]) -> [UIImage?] {
        var pictures : [UIImage?] = []
        for article in array {
            pictures.append(UIImage(data: article.image! as Data))
        }
        return pictures
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allArticles.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articleChosen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articleChosen" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! CreateOrEditViewController
                controller.articleToEdit = allArticles[indexPath.row]
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! DiaryTableViewCell
        let currentCellData = allArticles[indexPath.row]
        cell.title.text = currentCellData.title
        cell.title.numberOfLines = 0
        cell.content.text = currentCellData.content
        cell.content.numberOfLines = 0
        cell.articleImage.image = picturesForArticles[indexPath.row]
//        cell.articleImage.image = UIImage(data: currentCellData.image! as Data)
        cell.dateCreated.text = dateFormatter.string(from: currentCellData.creationdate! as Date)
        if currentCellData.creationdate == currentCellData.modificationdate {
            cell.dateModified.text = dateFormatter.string(from: currentCellData.modificationdate! as Date)
        } else {
            cell.dateModified.text = ""
        }
        return cell
    }
}

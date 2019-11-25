//
//  ViewController.swift
//  svovchyn2019
//
//  Created by stevevovchyna on 11/24/2019.
//  Copyright (c) 2019 stevevovchyna. All rights reserved.
//

import UIKit
import svovchyn2019

class ViewController: UIViewController {
    
    let articleManager = ArticleManager()
    var allArticles : [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here's the setup we have - see the article array now...")
        allArticles = articleManager.getAllArticles()
        print(allArticles.count)
        print("and now let's create one new article")
        let newOne = articleManager.newArticle()
        newOne.title = "Article 1"
        newOne.language = "English"
        newOne.content = "some content"
        newOne.creationdate = NSDate()
        newOne.modificationdate = NSDate()
        print("saving the context...")
        articleManager.save()
        print("adding to the array...")
        allArticles = articleManager.getAllArticles()
        print("let's print our general array and see the result!!!")
        print(allArticles)
        print("seems like everything's there! or am I being too optimistic?")
//        print("And how about deleting the first one?")
//        articleManager.removeArticle(article: allArticles[0])
//        allArticles = articleManager.getAllArticles()
//        print("and here's the result!")
//        print(allArticles.count)
        print("let's find an article?")
        let englishArticles = articleManager.getArticles(withLang: "English")
        let frenchArticles = articleManager.getArticles(withLang: "French")
        let articlesContainingWordContent = articleManager.getArticles(containString: "content")
        let articlesContainingWord42 = articleManager.getArticles(containString: "42")
        print("here's the result!!!")
        print("Articles in English: \(englishArticles.count)")
        print("articles in French: \(frenchArticles.count)")
        print("articles containintg word 'content': \(articlesContainingWordContent.count)")
        print("articles containintg word '42': \(articlesContainingWord42.count)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


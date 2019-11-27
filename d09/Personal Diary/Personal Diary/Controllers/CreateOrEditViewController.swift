//
//  CreateOrEditViewController.swift
//  Personal Diary
//
//  Created by Steve Vovchyna on 26.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import svovchyn2019



class CreateOrEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    let imagePicker = UIImagePickerController()
    let articleManager = ArticleManager()
    var pictureIsSelected : Bool = false
    var articleToEdit : Article?
    var editMode : Bool = false
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        contentField.delegate = self
        titleField.addTarget(self, action: #selector(fieldChanged(_:)), for: .editingChanged)
        saveButton.isEnabled = false
        if let article = articleToEdit {
            titleField.text = article.title
            contentField.text = article.content
            imagePreview.image = UIImage(data: article.image! as Data)
            saveButton.isEnabled = true
            editMode = true
            pictureIsSelected = true
        }
    }
    
    @IBAction func saveArticle(_ sender: UIBarButtonItem) {
        let title = titleField.text!
        let content = contentField.text!
        let image = normalizeImageOrientation(img: imagePreview.image!).pngData() as NSData?
        let date = NSDate()
        let language = Locale.current.languageCode

        if editMode {
            articleToEdit?.title = title
            articleToEdit?.content = content
            articleToEdit?.image = image
            articleToEdit?.modificationdate = date
            self.navigationController?.popViewController(animated: true)
        } else {
            let newArticle = articleManager.newArticle()
            newArticle.title = title
            newArticle.content = content
            newArticle.image = image
            newArticle.creationdate = date
            newArticle.modificationdate = date
            newArticle.language = language
            articleManager.save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.view.layoutIfNeeded()
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        titleField.resignFirstResponder()
        contentField.resignFirstResponder()
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func fieldChanged(_ newNameField: UITextField) {
        if titleField.text!.isEmpty || contentField.text!.isEmpty || !pictureIsSelected {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if contentField.text!.isEmpty || titleField.text!.isEmpty || !pictureIsSelected {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePreview.image = image
            if !titleField.text!.isEmpty && !contentField.text!.isEmpty {
                saveButton.isEnabled = true
            }
            pictureIsSelected = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func normalizeImageOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) { return img }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }    
}

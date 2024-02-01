//
//  ViewController.swift
//  Notes
//
//  Created by user on 29.01.2024.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate{
    
    var titleNote: String!
    var textNote: String!
    
    
    var notesArr: [Notes] = []
    
    let storageNotes = CoreDataManager()
    
    var isEditNote: Bool = false
    
    @IBOutlet var TitleTF: UITextField!
    
    @IBOutlet var TextMain: UITextView!
    
    @IBOutlet var sizeTextButton: UIButton!
    
    
    @IBOutlet var viewChangeButton: UIView!
    var fontLarge = false
    @IBAction func sizeTextButtonAction(_ sender: Any) {
        let boldText = " "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = " "
        let normalString = NSMutableAttributedString(string:normalText)
        if fontLarge{
            TextMain.attributedText = normalString
        }else{
            TextMain.attributedText = attributedString
        }
        
    }
    
    var saveTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleTF.text = titleNote ?? "Без названия"
        saveTitle = TitleTF.text ?? "Без названия"
        TextMain.text = textNote ?? "Текст"
        if !isEditNote{
            let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddButton))
            navigationItem.rightBarButtonItem = buttonAdd
        }else{
            let buttonChange = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionChangeButton))
            navigationItem.rightBarButtonItem = buttonChange
        }
        
        notesArr = CoreDataManager.shared.fetchNotes()
        var k = 0
        while notesArr.count > k{
            print(notesArr[k].titleNote ?? " ")
            k += 1
        }

    }

    

    
    @objc func actionAddButton(){
        CoreDataManager.shared.createNote(title: TitleTF.text ?? "", text: TextMain.text ?? "", complited: false)
        
        navigationController?.popViewController(animated: true)
    }
    @objc func actionChangeButton(){
        CoreDataManager.shared.updateNote(title: saveTitle, newTitle: TitleTF.text, text: TextMain.text, complited: false)
        
        navigationController?.popViewController(animated: true)
    }

    


}


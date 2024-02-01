//
//  TableViewController.swift
//  Notes
//
//  Created by user on 29.01.2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    let storageNote = StorageNotes()
    
    var notesArr: [Notes] = []
    var n: [Bool] = [false, true]
    var markNotes = [false: [Notes](), true : [Notes]()]
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CellNote", bundle: nil), forCellReuseIdentifier: "CellNote")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedButton))
        let delButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButton))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = delButton
        if UserDefaults.standard.bool(forKey: "didAddStandartNote") == false{
            CoreDataManager.shared.createNote(title: "First Note", text: "Привет меня зовут егор и мне 18 лет! Занимаюсь разработкой на iOS уже 3 год. Не успел доделать пару функций, поздно увидел сообщение :(", complited: false)
            UserDefaults.standard.set(true, forKey: "didAddStandartNote")
        }
        
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
        for i in notesArr{
            print(i.complitedNote)
        }
    }
    
    private func loadNotes(){
        notesArr = CoreDataManager.shared.fetchNotes()
        var comlNote = [Notes]()
        var notComlNote = [Notes]()
        for i in notesArr{
            markNotes[i.complitedNote]?.append(i)
        }
        notesArr.removeAll()
        for (n, note) in markNotes{
            if n == true{
                comlNote += note
            }else{
                notComlNote += note
            }
        }
        notesArr = comlNote + notComlNote
        notesArr.reverse()
        markNotes = [false: [Notes](), true : [Notes]()]
        print(notesArr)
        
        
        tableView.reloadData()
    }
    
    private func complitNote(indexPath: IndexPath){
        notesArr[indexPath.row].complitedNote = notesArr[indexPath.row].complitedNote ? false : true
        CoreDataManager.shared.updateNote(title: notesArr[indexPath.row].titleNote ?? "", complited: notesArr[indexPath.row].complitedNote)
        loadNotes()
       
    }
    
    
    @objc func tappedButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let descriptionScreen = storyboard.instantiateViewController(withIdentifier: "AddAndRedaction") as! ViewController
        
        navigationController?.pushViewController(descriptionScreen, animated: true)
        }
    @objc func deleteButton(){
        
        if tableView.isEditing {
            tableView.isEditing = false
            let delButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButton))
            navigationItem.leftBarButtonItem = delButton
        }else{
            tableView.isEditing = true
            let delButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteButton))
            navigationItem.leftBarButtonItem = delButton
        }
        
        }
    
    

    // MARK: - Table view data source
    
    // редактирование таблицы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        CoreDataManager.shared.deleteNote(with: notesArr[indexPath.row].titleNote ?? "")
        loadNotes()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let _ = notesArr[indexPath.row].titleNote else{
            return nil
        }
        
        let swipeAction = UIContextualAction(style: .normal, title: "Изменить") {_,_,_ in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAndRedaction") as! ViewController
            storyboard.titleNote = self.notesArr[indexPath.row].titleNote
            storyboard.textNote = self.notesArr[indexPath.row].textNote
            storyboard.isEditNote = true
            
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        let actionConfigur = UISwipeActionsConfiguration(actions: [swipeAction])
        return actionConfigur
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath) as! CellNote
        
        cell.Lable.text = notesArr[indexPath.row].titleNote
        
        cell.LableInformation.text = notesArr[indexPath.row].textNote
        
        if notesArr[indexPath.row].complitedNote{
            cell.Lable.textColor = .opaqueSeparator
            cell.ImageSwitch.tintColor = .opaqueSeparator
            cell.ImageSwitch.image = UIImage(systemName: "circle.fill")
        }else{
            cell.Lable.textColor = .label
            cell.ImageSwitch.tintColor = .link
            cell.ImageSwitch.image = UIImage(systemName: "circle")
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        complitNote(indexPath: indexPath)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

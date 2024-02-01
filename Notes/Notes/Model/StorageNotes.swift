import Foundation
import UIKit
import CoreData


protocol storNote{
    func addNotes() -> [notesProtocol]
}


class StorageNotes: storNote{

    
    
    
    func addNotes()-> [notesProtocol]{
        
        let arrNotes: [notesProtocol] =
        [notes(title: "First Note", text: "Привет меня зовут егор и мне 18 лет! Занимаюсь разработкой на iOS уже 3 год. Не успел доделать пару функций, поздно увидел сообщение :(", priority: true, comleted: false)]
        
        return arrNotes
    }
    
    
    
    
}

public final class CoreDataManager: NSObject{
    public static let shared = CoreDataManager()
    public override init() {}
    
    private var appDelegate: AppDelegate{
        UIApplication.shared.delegate as! AppDelegate
    }
    private var context: NSManagedObjectContext{
        appDelegate.persistentContainer.viewContext
    }
    
    public func createNote(title: String, text: String, complited: Bool){
        guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "Notes", in: context) else { return }
        let note = Notes(entity: noteEntityDescription, insertInto: context)
        note.textNote = text
        note.titleNote = title
        note.complitedNote = complited
        
        appDelegate.saveContext()
    }
    
    public func fetchNotes() -> [Notes]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
            return try context.fetch(fetchRequest) as! [Notes]
        } catch{
            print(error.localizedDescription)
        }
        return []
    }
    
    public func updateNote(title: String, newTitle: String? = nil, text: String? = nil, complited: Bool){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
            guard let notes = try? context.fetch(fetchRequest) as? [Notes],
                  let note = notes.first(where: { $0.titleNote == title }) else{
                return }
            if newTitle == nil, text == nil{
                note.textNote = note.textNote
                note.titleNote = note.titleNote
            }else if newTitle == nil{
                note.titleNote = note.titleNote
                note.textNote = text
            }else if text == nil{
                note.textNote = note.textNote
                note.titleNote = newTitle
            }else{
                note.textNote = text
                note.titleNote = newTitle
            }
            note.complitedNote = complited
            
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllNotes(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
            let notes = try? context.fetch(fetchRequest) as? [Notes]
            notes?.forEach {context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    public func deleteNote(with title: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
           guard let notes = try? context.fetch(fetchRequest) as? [Notes],
                 let note = notes.first(where: { $0.titleNote == title }) else{
               return }
            context.delete(note)
        }
        appDelegate.saveContext()
    }
    
}

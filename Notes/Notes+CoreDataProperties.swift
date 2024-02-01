//
//  Notes+CoreDataProperties.swift
//  Notes
//
//  Created by user on 29.01.2024.
//
//

import Foundation
import CoreData

@objc(Notes)
public class Notes: NSManagedObject {}


extension Notes{

    @NSManaged public var titleNote: String?
    @NSManaged public var textNote: String?
    @NSManaged public var complitedNote: Bool

}

extension Notes: Identifiable {

}

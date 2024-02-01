//
//  Body.swift
//  Notes
//
//  Created by user on 29.01.2024.
//

import Foundation

protocol notesProtocol{
    var title: String {get}
    var text: String {get}
    
    var priority: Bool {get}
    
    var comleted: Bool {get}
}
enum noteIsCompl: Int{
    case complited
    case notComolited
}

struct notes: notesProtocol{
    var title: String
    var text: String
    
    var priority: Bool
    
    var comleted: Bool

}


//
//  Run.swift
//  Treads
//
//  Created by juger rash on 04.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import Foundation
import RealmSwift

class Run : Object { //When you use realm you have to inherit from Object and u have to use dynamic with variables
    dynamic public private(set) var id = "" // every object needs an id to find it later when u want to search for something
    dynamic public private(set) var date = NSDate() // this will take the current time
    dynamic public private(set) var pace = 0
    dynamic public private(set) var distance = 0.0
    dynamic public private(set) var duration = 0
    
    override class func primaryKey() -> String { // every obeject has a primaryKey and it's unique
        return "id"
    }
    
    override class func indexedProperties() -> [String] { // this for sorting
        return ["pace" , "date" , "duration"]
    }
    
    convenience init(pace : Int , distance : Double , duration : Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
    
}

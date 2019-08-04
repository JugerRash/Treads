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
    @objc dynamic public private(set) var id = "" // every object needs an id to find it later when u want to search for something
    @objc dynamic public private(set) var date = NSDate() // this will take the current time
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    // notice we added to our variables @objc to be readable by the swift 4
    
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
    
    
    static func addRunTORealm(pace : Int , distacne : Double , duration : Int) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distacne, duration: duration)
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()// this one just for safety and it's good to have it
                }
            } catch {
                debugPrint("Erorr Adding run to realm")
            }
        }
    }
    
    static func getAllRuns() -> Results<Run>? { // the Results its the same as the dicitionary and it's not orederd and it has to be optional cuz we are getting data from realm 
        do {
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        } catch {
            return nil
        }
        
    }
    
}

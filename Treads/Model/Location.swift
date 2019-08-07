//
//  Location.swift
//  Treads
//
//  Created by juger rash on 05.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var longitude = 0.0

    convenience init(latitude : Double , longitude : Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}

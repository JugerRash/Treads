//
//  Extensions.swift
//  Treads
//
//  Created by juger rash on 31.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import Foundation

extension Double {
    func metersToMiles(places : Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34 ) * divisor).rounded() / divisor
    }
}

//
//  LogCell.swift
//  Treads
//
//  Created by juger rash on 26.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    @IBOutlet weak var runTimeLbl: UILabel!
    @IBOutlet weak var runDistanceLbl: UILabel!
    @IBOutlet weak var avgPaceLbl: UILabel!
    @IBOutlet weak var runDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(run : Run){
        self.runTimeLbl.text = run.duration.formatingTimeSecondsToHours()
        self.runDistanceLbl.text = "\(run.distance.metersToMiles(places: 2))"
        self.avgPaceLbl.text = run.pace.formatingTimeSecondsToHours()
        self.runDateLbl.text = run.date.getDateString()
    }

}

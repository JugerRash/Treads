//
//  RunLogVC.swift
//  Treads
//
//  Created by juger rash on 23.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class RunLogVC: UIViewController {

    // Outlets -:
    @IBOutlet weak var tableView: UITableView!
    // Variables -:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.dataSource = self
    }


}

extension RunLogVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LOG_CELL , for: indexPath) as? LogCell {
            guard let run = Run.getAllRuns()?[indexPath.row] else {
                return LogCell()
            }
            cell.configureCell(run: run)
            return cell
        }else {
            return LogCell()
        }
    }
    
}


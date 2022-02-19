//
//  ScorecardTableViewCell.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/6/22.
//

import UIKit

// TODO: rework autolayout + row height calculation/estimation
// TODO: add colored background based on par performance?
// This class/table view cell provides a custom cell for scorecard information to be displayed in ScorecardsTableViewController
class ScorecardsTableViewCell: UITableViewCell {
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var scorecardDateLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

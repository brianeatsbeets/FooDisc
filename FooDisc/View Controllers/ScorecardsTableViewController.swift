//
//  ScorecardTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/6/22.
//

import UIKit

// This class/table view controller provides a table view that lists Course objects
class ScorecardsTableViewController: UITableViewController {
    
    // MARK: Variable declarations
    
    var scorecards: [Scorecard] = []
    
    // MARK: Class functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scorecards = Scorecard.fetchScorecardData()
        tableView.register(UINib(nibName: "ScorecardsTableViewCell", bundle: nil), forCellReuseIdentifier: "ScorecardsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scorecards = Scorecard.fetchScorecardData()
        
        // Import sample scorecards if no scorecard data is present
        if scorecards.isEmpty {
            scorecards = Scorecard.loadSampleScorecards()
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scorecards.count
    }

    // Cell for row at
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScorecardsCell", for: indexPath) as! ScorecardsTableViewCell
        let scorecard = scorecards[indexPath.row]
        
        cell.courseNameLabel.text = scorecard.course.title
        
        cell.scorecardDateLabel.text = {
            
            // Configure date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            return dateFormatter.string(from: scorecard.date)
        }()
        
        cell.scoreLabel.text = {
            
            // Check if scorecard is compelte
            if scorecard.isScorecardComplete {
            
                // Configure total par
                var score = ""
                if scorecard.totalPar > 0 {
                    score = "+"
                }
                
                score += "\(scorecard.totalPar) (\(scorecard.totalScore))"
                
                return score
            } else {
                return "Incomplete round"
            }
        }()

        return cell
    }
}

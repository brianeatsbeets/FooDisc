//
//  DiscTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 3/8/22.
//

import UIKit

// TODO: review/remediate warning caused in unwind by tableView.reloadRows/.insertRows
// TODO: review unwind segue and compare to alternate implementations in app
class DiscTableViewController: UITableViewController, DiscCellDelegate {
    
    // MARK: Properties
    
    var discs = [Disc]()
    
    // MARK: Class functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedDiscs = Disc.loadDiscs() {
            discs = savedDiscs
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscCell", for: indexPath) as! DiscTableViewCell
        cell.delegate = self
        
        let disc = discs[indexPath.row]
        cell.discColorView.backgroundColor = disc.color
        if let imageData = disc.imageData {
            cell.discImageView.image = UIImage(data: imageData)
        }
        cell.discNameLabel.text = disc.name
        cell.discAttributesRowOneLabel.text = disc.manufacturer + " | " + disc.plastic + " | " + String(disc.weightInGrams) + "g"
        cell.discAttributesRowTwoLabel.text = disc.type.description + " - " + String(disc.speed) + "|" + String(disc.glide) + "|" + String(disc.turn) + "|" + String(disc.fade)
        cell.inBagButton.isSelected = disc.inBag

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            discs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Disc.saveDiscs(discs)
        }
    }
    
    // MARK: DiscCellDelegate function
    
    func inBagToggled(sender: DiscTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var disc = discs[indexPath.row]
            disc.inBag.toggle()
            discs[indexPath.row] = disc
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            Disc.saveDiscs(discs)
        }
    }

    // MARK: - Navigation
    
    @IBAction func unwindToDiscList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as!
           DiscDetailTableViewController
    
        if let disc = sourceViewController.disc {
            if let indexOfExistingDisc = discs.firstIndex(of: disc) {
                // Update existing row
                discs[indexOfExistingDisc] = disc
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingDisc, section: 0)], with: .automatic)
            } else {
                // Add new row
                let newIndexPath = IndexPath(row: discs.count, section: 0)
                discs.append(disc)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        Disc.saveDiscs(discs)
    }
    
    @IBSegueAction func editDisc(_ coder: NSCoder, sender: Any?) -> DiscDetailTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailController = DiscDetailTableViewController(coder: coder)
        detailController?.disc = discs[indexPath.row]
        
        return detailController
    }

}

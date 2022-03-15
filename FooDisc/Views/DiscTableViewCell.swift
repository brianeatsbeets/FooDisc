//
//  DiscTableViewCell.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 3/11/22.
//

import UIKit

protocol DiscCellDelegate: AnyObject {
    func inBagToggled(sender: DiscTableViewCell)
}

class DiscTableViewCell: UITableViewCell {
    
    @IBOutlet var discColorView: UIView!
    @IBOutlet var discImageView: UIImageView!
    @IBOutlet var discNameLabel: UILabel!
    @IBOutlet var discAttributesRowOneLabel: UILabel!
    @IBOutlet var discAttributesRowTwoLabel: UILabel!
    @IBOutlet var inBagButton: UIButton!
    
    weak var delegate: DiscCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func inBagButtonTapped() {
        delegate?.inBagToggled(sender: self)
    }
}

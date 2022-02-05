//
//  DisabledCursorTextField.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/28/22.
//

import UIKit

// This class/text field is used fo coordinate text fields to prevent user from moving cursor back to beginning of text field, which will prevent "rogue" minus signs
// "Rogue" minus signs will appear if a user adds a minus sign, moves the cursor to the beginning, adds more numbers, and taps the polarity button again
class DisabledCursorTextField: UITextField {
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}

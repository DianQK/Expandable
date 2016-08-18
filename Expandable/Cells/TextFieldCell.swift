//
//  TextFieldCell.swift
//  Expandable
//
//  Created by 宋宋 on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    
    var placeholder: String? {
        get {
            return textField?.placeholder
        }
        set {
            textField?.placeholder = newValue
        }
    }
    
    var rx_text: ControlProperty<String> {
        return textField.rx_text
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

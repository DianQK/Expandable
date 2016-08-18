//
//  SwitchCell.swift
//  Expandable
//
//  Created by 宋宋 on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SwitchCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var switchView: UISwitch!
    
    var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
        }
    }
    
    var rx_isOn: ControlProperty<Bool> {
        return switchView.rx_value
    }

}

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
    @IBOutlet fileprivate weak var switchView: UISwitch!

    var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
        }
    }

}

extension Reactive where Base: SwitchCell {
    var isOn: ControlProperty<Bool> {
        return base.switchView.rx.value
    }
}

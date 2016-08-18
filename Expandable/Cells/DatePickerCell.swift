//
//  DatePickerCell.swift
//  Expandable
//
//  Created by DianQK on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatePickerCell: UITableViewCell {

    @IBOutlet private weak var datePicker: UIDatePicker!
    
    var rx_date: ControlProperty<NSDate> {
        return datePicker.rx_date
    }

}

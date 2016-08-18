//
//  SliderCell.swift
//  Expandable
//
//  Created by DianQK on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SliderCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    
    var rx_value: ControlProperty<Int> {
        let observer = UIBindingObserver<UISlider, Int>(UIElement: slider) { (slider, value) in
            slider.value = Float(value)
        }.asObserver()
        return ControlProperty(values: slider.rx_value.map(Int.init), valueSink: observer)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

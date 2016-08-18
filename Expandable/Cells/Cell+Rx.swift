//
//  Cell+Rx.swift
//  Expandable
//
//  Created by DianQK on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private var prepareForReuseBag: Void = ()

extension UITableViewCell {
    var rx_prepareForReuse: Observable<Void> {
        return Observable.of(self.rx_sentMessage(#selector(UITableViewCell.prepareForReuse)).map { _ in () }, self.rx_deallocated).merge()
    }
    
    var rx_prepareForReuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(self, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(self, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = self.rx_sentMessage(#selector(UITableViewCell.prepareForReuse))
            .subscribeNext { [weak self] _ in
                let newBag = DisposeBag()
                objc_setAssociatedObject(self, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
        return bag
    }
}

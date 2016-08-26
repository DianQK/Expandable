//
//  ViewController.swift
//  Expandable
//
//  Created by DianQK on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
//import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let dataSource = RxTableViewSectionedAnimatedDataSource<ProfileSectionModel>()
    private let disposeBag = DisposeBag()

    let personalSection = Variable(
        ProfileSectionModel(model: .personal, items: [
            ProfileItem.info(title: Variable<String>("Unknown"), type: .fullname(first: Variable<String>(""), last: Variable<String>("Unknown"))),
            ProfileItem.info(title: Variable<String>("Unknown"), type: .dateOfBirth(Variable<Date>(Date()))),
            ProfileItem.info(title: Variable<String>("Unknown"), type: .maritalStatus(isMarried: Variable<Bool>(false))),
        ])
    )

    let preferencesSection = Variable(
        ProfileSectionModel(model: .preferences, items: [
            ProfileItem.info(title: Variable<String>("Unknown"), type: .favoriteSport(Variable<String>("Unknown"))),
            ProfileItem.info(title: Variable<String>("Unknown"), type: .favoriteColot(Variable<String>("Unknown"))),
        ])
    )

    let workExperienceSection = Variable(
        ProfileSectionModel(model: .workExperience, items: [
            ProfileItem.info(title: Variable<String>("Unknown"), type: .level(Variable<Int>(0))),
        ])
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        for item in [personalSection.value, preferencesSection.value, workExperienceSection.value]
            .flatMap({ $0.items }) {
            switch item {
            case let .info(title, type):
                switch type {
                case let .fullname(first, last):
                    Observable.combineLatest(first.asObservable(), last.asObservable()) { $0 + " " + $1 }
                        .skip(1)
                        .bindTo(title)
                        .addDisposableTo(disposeBag)
                case let .dateOfBirth(date):
                    date.asObservable()
                        .map(DateFormatter().config.longStyle.view.string)
                        .bindTo(title)
                        .addDisposableTo(disposeBag)
                case let .maritalStatus(isMarried):
                    isMarried.asObservable()
                        .skip(1)
                        .map { $0 ? "Married" : "Single" }
                        .bindTo(title)
                        .addDisposableTo(disposeBag)
                case let .favoriteSport(favorite):
                    favorite.asObservable()
                        .bindTo(title)
                        .addDisposableTo(disposeBag)
                case let .favoriteColot(favorite):
                    favorite.asObservable()
                        .bindTo(title)
                        .addDisposableTo(disposeBag)
                case let .level(level):
                    level.asObservable()
                        .map(String.init)
                        .bindTo(title)
                        .addDisposableTo(disposeBag)
                    break
                }
            default:
                break
            }
        }

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .fade)

        Observable.combineLatest(personalSection.asObservable(), preferencesSection.asObservable(), workExperienceSection.asObservable()) {
            return [$0, $1, $2]
        }
            .shareReplay(1)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            switch item {
            case let .info(title, type):
                let infoCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.normalCell, for: indexPath)!
                infoCell.detailTextLabel?.text = type.title
                if let textLabel = infoCell.textLabel {
                    title.asObservable()
                        .map(Optional.init)
                        .bindTo(textLabel.rx.text)
                        .addDisposableTo(infoCell.rx.prepareForReuseBag)
                }
                return infoCell
            case let .textField(text, placeholder):
                let textFieldCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldCell, for: indexPath)!
                textFieldCell.placeholder = placeholder
                (textFieldCell.rx.text <-> text).addDisposableTo(textFieldCell.rx.prepareForReuseBag)
                return textFieldCell
            case let .datePick(date):
                let datePickerCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.datePickerCell, for: indexPath)!
                (datePickerCell.rx.date <-> date).addDisposableTo(datePickerCell.rx.prepareForReuseBag)
                return datePickerCell
            case let .status(title, isOn):
                let switchCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.switchCell, for: indexPath)!
                switchCell.title = title
                (switchCell.rx.isOn <-> isOn).addDisposableTo(switchCell.rx.prepareForReuseBag)
                return switchCell
            case let .title(title, _):
                let titleCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.normalItemCell, for: indexPath)!
                titleCell.textLabel?.text = title
                return titleCell
            case let .level(level):
                let sliderCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sliderCell, for: indexPath)!
                (sliderCell.rx.value <-> level).addDisposableTo(sliderCell.rx.prepareForReuseBag)
                return sliderCell
            }
        }

        dataSource.titleForHeaderInSection = { dataSource, section in
            return dataSource.sectionAtIndex(section).model.rawValue
        }

        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self](indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            var section = self.dataSource.sectionModels[indexPath.section]
            let item = section.items[indexPath.item]
            switch item {
            case .info:
                let newItems: Array<ProfileItem>
                if let nextItem = section.items.safe[indexPath.row + 1], !nextItem.isInfo {
                    newItems = section.items.reduce((result: Array<ProfileItem>(), ignore: false), { (acc, x) in
                        switch x {
                        case .info where x == item:
                            return (result: acc.result + [x], ignore: true)
                        case .info:
                            return (result: acc.result + [x], ignore: false)
                        default:
                            if acc.ignore {
                                return acc
                            }
                            return (result: acc.result + [x], ignore: false)
                        }
                    }).result
                } else {
                    newItems = section.items.reduce(Array<ProfileItem>(), { (acc, x) in
                        if x == item {
                            return acc + [x] + x.childItems
                        } else {
                            return acc + [x]
                        }
                    })
                }
                switch section.model {
                case .personal:
                    self.personalSection.value = ProfileSectionModel(model: ProfileSectionType.personal, items: newItems)
                case .preferences:
                    self.preferencesSection.value = ProfileSectionModel(model: ProfileSectionType.preferences, items: newItems)
                case .workExperience:
                    self.workExperienceSection.value = ProfileSectionModel(model: ProfileSectionType.workExperience, items: newItems)
                }
            case let .title(title, favorite):
                favorite.value = title
            default:
                break
            }

        })
            .addDisposableTo(disposeBag)
    }

}

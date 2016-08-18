//
//  Profile.swift
//  Expandable
//
//  Created by 宋宋 on 8/17/16.
//  Copyright © 2016 T. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

enum ProfileItemType {
    case fullname(first: Variable<String>, last: Variable<String>)
    case dateOfBirth(Variable<NSDate>)
    case maritalStatus(isMarried: Variable<Bool>)
    case favoriteSport(Variable<String>)
    case favoriteColot(Variable<String>)
    case level(Variable<Int>)
    
    var title: String {
        switch self {
        case .fullname:
            return "Fullname"
        case .dateOfBirth:
            return "Date of Birth"
        case .maritalStatus:
            return "Marital Status"
        case .favoriteSport:
            return "Favorite Sport"
        case .favoriteColot:
            return "Favorite Colot"
        case .level:
            return "Level"
        }
    }
}

enum ProfileSectionType: String, IdentifiableType {
    case personal = "Personal"
    case preferences = "Preferences"
    case workExperience = "Work Experience"
    
    var identity: String {
        return rawValue
    }
}

enum ProfileItem {
    case info(title: Variable<String>, type: ProfileItemType)
    case textField(text: Variable<String>, placeholder: String)
    case datePick(Variable<NSDate>)
    case status(title: String, isOn: Variable<Bool>)
    case title(String, favorite: Variable<String>)
    case level(Variable<Int>)
    
    var isInfo: Bool {
        switch self {
        case .info:
            return true
        default:
            return false
        }
    }
}

extension ProfileItem: Hashable, Equatable, IdentifiableType {
    var hashValue: Int {
        switch self {
        case let .info(title, detail):
            return "0\(title.value)\(detail)".hashValue
        case let .textField(_, placeholder):
            return "1\(placeholder)".hashValue
        case let .datePick(date):
            return "2\(date.value)".hashValue
        case let .status(title, isOn):
            return "3\(title)\(isOn.value)".hashValue
        case let .title(title):
            return "4\(title)".hashValue
        case let .level(level):
            return "5\(level.value)".hashValue
        }
    }
    
    var identity: Int {
        return hashValue
    }
}

extension ProfileItem {
    var childItems: [ProfileItem] {
        switch self {
        case let .info(_, type):
            switch type {
            case let .fullname(first, last):
                return [ProfileItem.textField(text: first, placeholder: "Firstname"), ProfileItem.textField(text: last, placeholder: "Lastname")]
            case let .dateOfBirth(date):
                return [ProfileItem.datePick(date)]
            case let .maritalStatus(isMarried):
                return [ProfileItem.status(title: "Off = Single, On = Married", isOn: isMarried)]
            case let .favoriteSport(favorite):
                return [
                    ProfileItem.title("Football", favorite: favorite),
                    ProfileItem.title("Basketball", favorite: favorite),
                    ProfileItem.title("Baseball", favorite: favorite),
                    ProfileItem.title("Volleyball", favorite: favorite)
                ]
            case let .favoriteColot(favorite):
                return [
                    ProfileItem.title("Red", favorite: favorite),
                    ProfileItem.title("Green", favorite: favorite),
                    ProfileItem.title("Blue", favorite: favorite)
                ]
            case let .level(level):
                return [
                    ProfileItem.level(level)
                ]
            }
        default:
            return []
        }
    }
}

func == (lhs: ProfileItem, rhs: ProfileItem) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

typealias ProfileSectionModel = AnimatableSectionModel<ProfileSectionType, ProfileItem>
//
//  Valuable.swift
//  RealmManager
//
//  Created by Luca Celiento on 08/09/2019.
//  Copyright © 2019 Luca Celiento. All rights reserved.
//

import RealmSwift

protocol RealmPath {
    var pathComponent: String { get }
}

extension RealmPath {
    var pathComponentWithExtension: String {
        return pathComponent + ".realm"
    }
}

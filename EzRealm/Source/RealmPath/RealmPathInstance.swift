//
//  RealmPathCreator.swift
//  EzRealm
//
//  Created by Luca Celiento on 08/09/2019.
//  Copyright © 2019 Luca Celiento. All rights reserved.
//

import Foundation

public struct RealmPathInstance: RealmPath {
    public var pathComponent: String
    public init(pathComponent: String) {
        self.pathComponent = pathComponent
    }
}

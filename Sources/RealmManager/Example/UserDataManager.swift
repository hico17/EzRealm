//
//  UserDataManager.swift
//  Easy Guide
//
//  Created by Luca Celiento on 07/11/2018.
//  Copyright © 2018 Luca Celiento. All rights reserved.
//

import RealmSwift

private class UserDataManager: RealmDataManagerProtocol {
    
    typealias T = User

    static let shared = UserDataManager()
    
    func save(_ object: User) throws {
        try UserDataManager.dataManager.save(object)
    }
    
    func save(_ objects: [User]) throws {
        try UserDataManager.dataManager.save(objects)
    }
    
    func update(_ changes: (() throws -> Void)) throws {
        try UserDataManager.dataManager.update(changes)
    }
    
    func delete(_ object: User) throws {
        try UserDataManager.dataManager.delete(object)
    }
    
    func deleteAll() throws {
        try UserDataManager.dataManager.deleteAll()
    }
    
    func read<Element>(_ objectType: Element.Type) throws -> Results<Element> where Element : Object {
        return try UserDataManager.dataManager.read(objectType)
    }
    
    private static var dataManager = RealmDataManager(for: Realms.users, options: [.availableForBackground, .encrypted])
    
    private init() {}
}

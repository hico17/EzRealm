//
//  RealmDataManagerProtocol.swift
//  RealmManager
//
//  Created by Luca Celiento on 08/09/2019.
//  Copyright © 2019 Luca Celiento. All rights reserved.
//

import RealmSwift

// MARK: - RealmDataManagerProtocol
protocol RealmDataManagerProtocol {
    associatedtype T: Object
    /**
     Save synchronously the object on the Realm.
     - Parameter object: The object to save in the Realm.
     - Throws: `DataManagerError.realmOpeningFailed` if the function can not open the Realm for the selected configuration, `throw DataManagerError.writingFailed` if the function can not write data into the given Realm.
     */
    func save(_ object: T) throws
    /**
     Save synchronously the objects on the Realm.
     - Parameter objects: The objects to save in the Realm.
     - Throws: `DataManagerError.realmOpeningFailed` if the function can not open the Realm for the selected configuration, `throw DataManagerError.writingFailed` if the function can not write data into the given Realm.
     */
    func save(_ objects: [T]) throws
    /**
     Use this function to update changes synchronously for an entity that is part of the selected Realm.
     - Parameter changes: The changes to apply to an entity.
     - Throws: `DataManagerError.realmOpeningFailed` if the function can not open the Realm for the selected configuration, `throw DataManagerError.writingFailed` if the function can not write data into the given Realm. Can be thrown if the entity is not in the selected Realm.
     */
    func update(_ changes: (() throws -> Void)) throws
    /**
     Read synchronously all the objects of the selected type from the selected Realm.
     - Parameter objectType: The type of the object to read from the Realm.
     - Throws: `DataManagerError.realmOpeningFailed` if the function can not open the Realm for the selected configuration.
     */
    func read<Element>(_ objectType: Element.Type) throws -> Results<Element> where Element : Object
    /**
     Delete synchronously the object from the selected Realm.
     - Parameter object: The object to delete from the Realm.
     - Throws: `DataManagerError.realmOpeningFailed` if the function can not open the Realm for the selected configuration, `throw DataManagerError.writingFailed` if the function can not delete data from the selected Realm.
     */
    func delete(_ object: T) throws
    /**
     Delete synchronously all the objects from the selected Realm.
     */
    func deleteAll() throws
}

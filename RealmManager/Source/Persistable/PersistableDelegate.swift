//
//  DataManagerProtocol.swift
//  Easy Guide
//
//  Created by Luca Celiento on 06/11/2018.
//  Copyright © 2018 System Management. All rights reserved.
//

import RealmSwift

protocol PersistableDelegate: class {}

extension PersistableDelegate {
    /// Called before the object is saved, modified or deleted from Realm. It's a generic function, if you want more constraints, define the other functions.
    func willMakeRealmCall() throws {}
    /// Called before the object is saved on Realm.
    func willSaveOnRealm() throws {}
    /// Called before the object is deleted from Realm.
    func willDeleteFromRealm() throws {}
    /// Called before the object is updated on Realm.
    func willUpdateOnRealm() throws {}
    /// Called after the object has been saved, modified or deleted from Realm. It's a generic function, if you want more constraints, define the other functions.
    func didMakeRealmCall() throws {}
    /// Called after the object has been saved on Realm.
    func didSaveOnRealm() throws {}
    /// Called after the object has been deleted from Realm.
    func didDeleteFromRealm() throws {}
    /// Called after the object has been updated on Realm.
    func didUpdateOnRealm() throws {}
}

protocol PersistableOnMultipleRealms: PersistableDelegate where Self: Object {
    /// Save the object synchronously in the specified Realm.
    /// - Parameter realm: The Realm where to save the object.
    /// - Throws: Error if the specified Realm does not contain the object to save.
    func save(in realm: RealmPath) throws -> Void
    /// Delete the object synchronously from the specified Realm.
    /// - Parameter realm: The Realm where to save the object.
    /// - Throws: Error if the specified Realm does not contain the object to delete.
    func delete(from realm: RealmPath) throws -> Void
    /// Update the object synchronously from the specified Realm.
    /// - Parameter realm: The Realm where to save the object.
    /// - Throws: Error if the specified Realm does not contain the object to update.
    func update(from realm: RealmPath, changes: (() throws -> Void)) throws -> Void
}

extension PersistableOnMultipleRealms {
    func save(in realm: RealmPath) throws -> Void {
        try willMakeRealmCall()
        try willSaveOnRealm()
        try RealmDataManager(for: realm).save(self)
        try didMakeRealmCall()
        try didSaveOnRealm()
    }
    func delete(from realm: RealmPath) throws -> Void {
        try willMakeRealmCall()
        try willDeleteFromRealm()
        try RealmDataManager(for: realm).delete(self)
        try didMakeRealmCall()
        try didDeleteFromRealm()
    }
    func update(from realm: RealmPath, changes: (() throws -> Void)) throws -> Void {
        try willMakeRealmCall()
        try willUpdateOnRealm()
        try RealmDataManager(for: realm).update(changes)
        try didMakeRealmCall()
        try didUpdateOnRealm()
    }
}

/// Adapt to this protocol to use the standard
protocol PersistableOnRealm: PersistableOnMultipleRealms {
    /// Specify in which Realm belongs the object.
    static var realmPath: RealmPath { get }
    /// Save the object synchronously in the Realm specified in the realmType proprerty.
    /// - Throws: Error if the specified Realm does not contain the object to save.
    func save() throws
    /// Delete the object synchronously from the Realm specified in the realmType proprerty.
    /// - Throws: Error if the specified Realm does not contain the object to delete.
    func delete() throws
    /// Update the object synchronously from the Realm specified in the realmType proprerty.
    /// - Throws: Error if the specified Realm does not contain the object to update.
    func update(changes: (() throws -> Void)) throws
}

extension PersistableOnRealm {
    func save() throws {
        try save(in: Self.realmPath)
    }
    func delete() throws {
        try delete(from: Self.realmPath)
    }
    func update(changes: (() throws -> Void)) throws {
        try update(from: Self.realmPath, changes: changes)
    }
}

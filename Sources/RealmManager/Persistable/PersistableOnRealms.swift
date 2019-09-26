//
//  PersistableOnRealms.swift
//  Realm Manager
//
//  Created by Luca Celiento on 06/11/2018.
//  Copyright © 2018 Luca Celiento. All rights reserved.
//

import RealmSwift

protocol PersistableOnRealms where Self: Object {
    /// The persisted instances of the object in the specified Realm.
    /// - Parameter realm: The Realm where to take the objects.
    static func persisted(in realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options]) -> [Self]
    /// Save the object synchronously in the specified Realm.
    /// - Parameter realm: The Realm where to save the object.
    /// - Throws: Error if the specified Realm does not contain the object to save.
    func save(in realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options]) throws -> Void
    /// Delete the object synchronously from the specified Realm.
    /// - Parameter realm: The Realm where to save the object.
    /// - Throws: Error if the specified Realm does not contain the object to delete.
    func delete(from realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options]) throws -> Void
    /// Update the object synchronously from the specified Realm.
    /// - Parameter realm: The Realm where to save the object.
    /// - Throws: Error if the specified Realm does not contain the object to update.
    func update(from realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options], _ changes: ((Self) throws -> Void)) throws -> Void
}

extension PersistableOnRealms {
    static func persisted(in realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options]) -> [Self] {
        guard let results = try? RealmDataManager(for: realm, options: options).read(self) else { return [] }
        return Array(results)
    }
    func save(in realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options]) throws -> Void {
        try willMakeRealmCall()
        try willSaveOnRealm()
        try RealmDataManager(for: realm, options: options).save(self)
        try didMakeRealmCall()
        try didSaveOnRealm()
    }
    func delete(from realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options]) throws -> Void {
        try willMakeRealmCall()
        try willDeleteFromRealm()
        try RealmDataManager(for: realm, options: options).delete(self)
        try didMakeRealmCall()
        try didDeleteFromRealm()
    }
    func update(from realm: RealmPath, withOptions options: [RealmConfigurationFactory.Options],_ changes: ((Self) throws -> Void)) throws -> Void {
        try willMakeRealmCall()
        try willUpdateOnRealm()
        try RealmDataManager(for: realm, options: options).update {
            try changes(self)
        }
        try didMakeRealmCall()
        try didUpdateOnRealm()
    }
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

/// Adapt to this protocol to use the standard
protocol PersistableOnRealm: PersistableOnRealms {
    /// The persisted instances of the object in the specified Realm.
    static func persisted() -> [Self]
    /// Specify in which Realm belongs the object.
    static var realmPath: RealmPath { get }
    /// Specify the options for the Realm in which will be stored the object.
    static var options: [RealmConfigurationFactory.Options] { get }
    /// Save the object synchronously in the Realm specified in the realmType proprerty.
    /// - Throws: Error if the specified Realm does not contain the object to save.
    func save() throws
    /// Delete the object synchronously from the Realm specified in the realmType proprerty.
    /// - Throws: Error if the specified Realm does not contain the object to delete.
    func delete() throws
    /// Update the object synchronously from the Realm specified in the realmType proprerty.
    /// - Throws: Error if the specified Realm does not contain the object to update.
    func update(_ changes: ((Self) throws -> Void)) throws
}

extension PersistableOnRealm {
    static func persisted() -> [Self] {
        return persisted(in: Self.realmPath, withOptions: Self.options)
    }
    static var options: [RealmConfigurationFactory.Options] {
        return []
    }
    func save() throws {
        try save(in: Self.realmPath, withOptions: Self.options)
    }
    func delete() throws {
        try delete(from: Self.realmPath, withOptions: Self.options)
    }
    func update(_ changes: ((Self) throws -> Void)) throws {
        try update(from: Self.realmPath, withOptions: Self.options, changes)
    }
}

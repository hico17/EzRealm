//
//  DataLayerFacade.swift
//  Easy Guide
//
//  Created by Luca Celiento on 24/07/18.
//  Copyright © 2018 Luca Celiento. All rights reserved.
//

import RealmSwift

// MARK: - DataLayer
class RealmDataManager: RealmDataManagerProtocol {
    
    typealias T = Object
    
    // MARK: Public implementation
    
    func save(_ object: T) throws {
        guard let realmConfiguration = realmConfiguration else {
            throw RealmDataManagerError.realmOpeningFailed
        }
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
            throw RealmDataManagerError.writingFailed
        }
    }
    
    func save(_ objects: [T]) throws {
        guard let realmConfiguration = realmConfiguration else {
            throw RealmDataManagerError.realmOpeningFailed
        }
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.add(objects)
            }
        } catch {
            print(error)
            throw RealmDataManagerError.writingFailed
        }
    }

    
    func update(_ changes: (() throws -> Void)) throws {
        guard let realmConfiguration = realmConfiguration, let realm = try? Realm(configuration: realmConfiguration) else {
            throw RealmDataManagerError.realmOpeningFailed
        }
        do {
            try realm.write(changes)
        } catch {
            throw RealmDataManagerError.writingFailed
        }
    }
    
    func read<Element>(_ objectType: Element.Type) throws -> Results<Element> where Element: Object {
        guard let realmConfiguration = realmConfiguration, let realm = try? Realm(configuration: realmConfiguration) else {
            throw RealmDataManagerError.realmOpeningFailed
        }
        
        realm.refresh()
        
        let results = realm.objects(objectType)
        return results
    }
    
    func delete(_ object: T) throws {
        guard let realmConfiguration = realmConfiguration, let realm = try? Realm(configuration: realmConfiguration) else {
            throw RealmDataManagerError.realmOpeningFailed
        }
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw RealmDataManagerError.writingFailed
        }
    }
    
    func deleteAll() throws {
        guard let realmConfiguration = realmConfiguration, let realm = try? Realm(configuration: realmConfiguration) else {
            throw RealmDataManagerError.realmOpeningFailed
        }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            throw RealmDataManagerError.writingFailed
        }
    }

    // MARK: Init
    
    required init(for realmPath: RealmPath, options: [RealmConfigurationFactory.Options]) {
        self.realmConfiguration = try? RealmConfigurationFactory(realmPath: realmPath, options: options).create()
    }
    
    // MARK: Private implementation
    private let realmConfiguration: Realm.Configuration?
}

// MARK: - DataManagerError

enum RealmDataManagerError: LocalizedError {
    case realmOpeningFailed
    case objectNotFound
    case writingFailed
    case invalidParameter
    case internalError
    var errorDescription: String? {
        switch self {
        case .realmOpeningFailed:
            return "Failed to get the Realm with the given type."
        case .objectNotFound:
            return "Failed to get the object from Realm."
        case .writingFailed:
            return "The writing transaction on the Realm failed."
        case .invalidParameter:
            return "Invalid parameter passed to the function."
        case .internalError:
            return "Internal error caused by computation errors."
        }
    }
}

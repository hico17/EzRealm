//
//  ManualRealmFactory.swift
//  Easy Guide
//
//  Created by Luca Celiento on 24/07/18.
//  Copyright © 2018 System Management. All rights reserved.
//

import Foundation
import RealmSwift

/// Class that helps you to create a new RealmConfiguration.
class RealmConfigurationFactory {
    
    // MARK: Public implementation
    
    func create(availableForBackground: Bool = true, encrypted: Bool = true) throws -> Realm.Configuration {
        
        do {
            
            guard let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                throw Error.openingFailed
            }
            
            let url = documentDirectory.appendingPathComponent(realmPath)
            
            let encryptionKey: Data? = encrypted ? getKeyFromKeychain() as Data : nil
            let realmConfiguration = Realm.Configuration(fileURL: url, encryptionKey: encryptionKey, readOnly: false)
            
            if availableForBackground {
                
                guard let realmFileURL = realmConfiguration.fileURL else {
                    throw Error.openingFileURLFailed
                }
                
                let realmFolderPath = realmFileURL.deletingLastPathComponent().path
                
                do {
                    // Removing the file protection for the realm url path.
                    try FileManager.default.setAttributes([FileAttributeKey.protectionKey : FileProtectionType.none], ofItemAtPath: realmFolderPath)
                } catch {
                    throw Error.removingFileProtectionFailed
                }
            }
            
            return realmConfiguration
        } catch {
            throw Error.openingFailed
        }
    }
    
    // MARK: Private implementation
    
    private let realmPath: String
    
    private func getKeyFromKeychain() -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.EncryptionKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }
        
        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")
        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
    }
    
    // MARK: Init
    
    /// Init the class with the chosen Realm type.
    init(withPath realmPath: RealmPath) {
        self.realmPath = realmPath.pathComponentWithExtension
    }
}

// MARK: - RealmConfigurationFactoryError

extension RealmConfigurationFactory {
    
    enum Error: LocalizedError {
        
        case openingFailed
        case openingFileURLFailed
        case removingFileProtectionFailed
        
        var errorDescription: String? {
            switch self {
            case .openingFailed:
                return "Failed to open or create the selected Realm."
            case .openingFileURLFailed:
                return "Failed to open the URL path for the Realm folder."
            case .removingFileProtectionFailed:
                return "Failed to remove file protection at the specified path."
            }
        }
    }
}

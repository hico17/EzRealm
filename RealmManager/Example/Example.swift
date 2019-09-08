//
//  Example.swift
//  RealmManager
//
//  Created by Luca Celiento on 10/09/2019.
//  Copyright © 2019 Luca Celiento. All rights reserved.
//

import RealmSwift

enum Realms: String, RealmPath {
    
    case users
    case persons
    
    var pathComponent: String {
        return self.rawValue
    }
}

final class User: Object {
    
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
}

extension User: PersistableOnRealm {
    
    static var realmPath: RealmPath {
        return Realms.users // RealmPathInstance(pathComponent: "users")
    }
    
    static var options: [RealmConfigurationFactory.Options] {
        return [.availableForBackground, .encrypted]
    }
    
    func willSaveOnRealm() throws {
        // Do something
    }
    
    func willDeleteFromRealm() throws {
        // Do something
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User()
        try? user.save()
        try? user.update { $0.firstName = "" }
        try? user.delete()
        print("Number of persisted users: \(User.persisted().count)")
    }
}

//
//  BaseDatos.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
lass SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
    
    private init() {
        
        var path = "BaseballDB.sqlite"
        
        if let dirs: [NSString] =          NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
                                                                               NSSearchPathDomainMask.AllDomainsMask, true) as [NSString] {
            
            let dir = dirs[0]
            path = dir.stringByAppendingPathComponent("BaseballDB.sqlite");
        }
        
        do {
            BBDB = try Connection(path)
        } catch _ {
            BBDB = nil
        }
    }
    
    func createTables() throws{
        do {
            try TeamDataHelper.createTable()
            try PlayerDataHelper.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}

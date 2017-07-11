//
//  SQLiteDataStorage.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//



import Foundation
import SQLite


enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}



protocol CRUDProtocolo {
    associatedtype B
    static func crearTabla() throws -> Void
    static func borrarTabla(nombreTabla: String) throws -> Void
    static func insertar(item: B) throws -> Int64
    static func borrar(item: B) throws -> Void
    static func actualizar(item: B) throws -> Int64
    static func ver() throws -> [B]?
}



class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
    
    public init() {
        
        var path = "BalizasDB.sqlite"
        
        if let dirs: [NSString] =          NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                               FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString] {
            
            let dir = dirs[0]
            path = dir.appendingPathComponent("BalizasDB.sqlite");
        }
        
        do {
            BBDB = try Connection(path)
        } catch _ {
            BBDB = nil
        }
    }
    
    func createTables() throws{
        do {
            try BalizasDBManager.crearTabla()
            try MotivoDBManager.crearTabla()
            try MascarasDBManager.crearTabla()
            try GruposDBManager.crearTabla()
            try GrupoMascaraDBManager.crearTabla()
            
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}

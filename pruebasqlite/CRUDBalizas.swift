//
//  CRUDBalizas.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation


import Foundation
import SQLite


typealias {
    
    
    
}

protocol BalizasProtocol {
    typealias B
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
}



class CRUDBalizas: BalizasProtocol {
    
    
    static let TABLE_NAME = "NSBaliza"
    
    static let table = Table(TABLE_NAME)
  
    private let tblBaliza = Table("NSbaliza")
    
    private let idNS = Expression<Int>("idNS")
    private let nombre = Expression<String>("nombre")
    private let idMaquina = Expression<Int>("idMaquina")
    private let idMaquinaLogica = Expression<Int>("idMaquinaLogica")
    
    private let idGMantes = Expression<Int>("idGMantes")
    
    private let idGMdentro = Expression<Int>("idGMdentro")
    
    private let idGMdespues = Expression<Int>("idGMdespues")
    
    private let fechorDesde = Expression<Int>("fechorDesde")
    private let fechorHasta = Expression<Int>("fechorHasta")
    
    
    private let idGMidantes = Expression<Int>("idGMidantes")
    
    private let idGMiddentro = Expression<Int>("idGMiddentro")
    
    private let idGMiddespues = Expression<Int>("idGMiddespues")
    

    
    
    
    
    
    
    typealias B = Baliza
    
    static func createTable() throws {
        guard let DB = shared.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(teamId, primaryKey: true)
                t.column(city)
                t.column(nickName)
                t.column(abbreviation)
            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.city != nil && item.nickName != nil && item.abbreviation != nil) {
            let insert = table.insert(city <- item.city!, nickName <- item.nickName!, abbreviation <- item.abbreviation!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.teamId {
            let query = table.filter(teamId == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(teamId == id)
        let items = DB.prepare(query)
        for item in  items {
            return Team(teamId: item[teamId] , city: item[city], nickName: item[nickName], abbreviation: item[abbreviation])
        }
        
        return nil
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = DB.prepare(table)
        for item in items {
            retArray.append(Team(teamId: item[teamId], city: item[city], nickName: item[nickName], abbreviation: item[abbreviation]))
        }
        
        return retArray
        
    }
}

//
//  GruposDBManager.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
//
//  MascarasDBManager.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation


//
//  TeamDataHelper.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
import SQLite



typealias GrupoModelo = (
    idgrupo: Int64?,
    nombre: String?
    
)


class GruposDBManager: CRUDProtocolo {
    
    
    
    
    static let TABLE_NAME = "Grupos"
    
    static let table = Table(TABLE_NAME)
    
    
    static let idgrupo = Expression<Int64>("idgrupo")
    static let nombre = Expression<String>("nombre")
    
    typealias G = GrupoModelo
    
    
    
    static func borrarTabla(nombreTabla: String) throws  {
        // borrar tabla
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let table = Table(nombreTabla)
        
        do {
            try DB.run(table.drop(ifExists: true))
            print("se ha borrado la tabla")
        } catch {
            print("Error al borrar la tabla ")
            
        }
        
    }
    
    
    static func crearTabla() throws {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {table in
                table.column(idgrupo, primaryKey: true)
                table.column(nombre)
                print("tabla grupos creada con exito")            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insertar(item: G) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        print("entro en insertar")
        if (item.idgrupo != nil) {
            let insert = table.insert(idgrupo <- item.idgrupo!,
                                      nombre <- item.nombre!            )
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    
                    print(DataAccessError.Insert_Error)
                    throw DataAccessError.Insert_Error
                }
                print("registro creado")
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    static func borrar (item: G) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.idgrupo {
            let query = table.filter(idgrupo == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    print(DataAccessError.Delete_Error)
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    
    
    static func actualizar(item: G)  throws -> Int64 {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let tablaFilter = table.filter(item.idgrupo! == idgrupo)
        //let balizas =  try DB.prepare(tablaFilter)
        
        do {
            
            let update = tablaFilter.update([idgrupo <- item.idgrupo!,
                                             nombre <- item.nombre!
                ])
            
            do {
                let rowId = try DB.run(update)
                guard rowId > 0 else {
                    
                    print(DataAccessError.Insert_Error)
                    throw DataAccessError.Insert_Error
                }
                print("registro creado")
                return Int64(rowId)
            } catch _ {
                throw DataAccessError.Insert_Error
            }
            
        }
    }
    
    
    
    
    
    static func buscar(id: Int64) throws -> G? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(id == idgrupo)
        let grupos =  try DB.prepare(query)
        for grupo in grupos {
            
            return GrupoModelo(
                idgrupo: grupo[idgrupo],
                nombre: grupo[nombre]
            )
            
        }
        
        return nil
        
    }
    
    static func ver() throws -> [G]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [G]()
        let grupos = try DB.prepare(table)
        for grupo in grupos {
            retArray.append(GrupoModelo(
                idgrupo: grupo[idgrupo],
                nombre: grupo[nombre]
             ))
        }
        
        return retArray
        
    }
}

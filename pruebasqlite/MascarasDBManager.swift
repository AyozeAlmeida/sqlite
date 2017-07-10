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



typealias MascaraModelo = (
    mascaraid: Int64?,
    mascarapermiso: Int64?
  
)


class MascarasDBManager: CRUDProtocolo {
    
    
    
    
    static let TABLE_NAME = "Mascaras"
    
    static let table = Table(TABLE_NAME)
    
    
    static let mascaraid = Expression<Int64>("mascaraid")
   
    static let mascarapermiso = Expression<Int64>("mascarapermiso")
    
    typealias M = MascaraModelo
    
    
    
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
                table.column(mascaraid, primaryKey: true)
                table.column(mascarapermiso)
               print("tabla MASCARAS creada con exito")            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insertar(item: M) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        print("entro en insertar")
        if (item.mascaraid != nil) {
            let insert = table.insert(mascaraid <- item.mascaraid!,
                                      mascarapermiso <- item.mascarapermiso!            )
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
    
    static func borrar (item: M) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.mascaraid {
            let query = table.filter(mascaraid == id)
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
    
    
    
    
    
    
    static func actualizar(item: M)  throws -> Int64 {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let tablaFilter = table.filter(item.mascaraid! == mascaraid)
        //let balizas =  try DB.prepare(tablaFilter)
        
        do {
            
            let update = tablaFilter.update([mascaraid <- item.mascaraid!,
                                             mascarapermiso <- item.mascarapermiso!
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
    
    
    
    
    
    static func buscar(id: Int64) throws -> M? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(id == mascaraid)
        let mascaras =  try DB.prepare(query)
        for mascara in  mascaras {
            
            return MascaraModelo(
                mascaraid: mascara[mascaraid],
                mascarapermiso: mascara[mascarapermiso]
             )
            
        }
        
        return nil
        
    }
    
    static func ver() throws -> [M]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [M]()
        let mascaras = try DB.prepare(table)
        for mascara in mascaras {
            retArray.append(MascaraModelo(
                mascaraid: mascara[mascaraid],
                mascarapermiso: mascara[mascarapermiso]
                
            ))
        }
        
        return retArray
        
    }
}

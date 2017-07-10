
import Foundation

import SQLite

import SwiftyJSON





/*
typealias GrupoMascaraModelo = (
    idgrupometodoid: Int64?,
    mascara: [MascaraModelo]?
)
*/



typealias PivotGrupoMascaraModelo = (
    idgrupo: Int64?,
    idmascara: Int64?
)



class GrupoMascaraDBManager {
    
    
 
   
    static let TABLE_NAME = "PivotGrupoMascara"
    
    static let table = Table(TABLE_NAME)
    
    
    static let idgrupometodoid = Expression<Int64>("idgrupo")
    static let mascara = Expression<Int64>("idmascara")
    
    
    
    typealias PGM = PivotGrupoMascaraModelo
    
    
    
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
                table.column(idgrupometodoid, primaryKey: true)
                table.column(mascara)
              
                print("tabla PivotGrupoMascara creada con exito")            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insertar(item: PGM) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        print("entro en insertar")
        if (item.idgrupometodoid != nil) {
            let insert = table.insert(idgrupometodoid <- item.idgrupo!, idmascara <- item.idmascara!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    
                    print(DataAccessError.Insert_Error)
                    throw DataAccessError.Insert_Error
                }
                print("registro creado en pivotgrupomascara")
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    static func borrar (item: PGM) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.idgrupometodoid {
            let query = table.filter(idgrupometodoid == id)
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
    
    
    static func actualizar(item: PGM)  throws -> Int64 {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(item.idgrupometodoid! == idgrupometodoid)
        let grupos =  try DB.prepare(query)
        
        do {
            let update = table.update([idgrupometodoid <- item.idgrupometodoid!,
                                       mascara <- item.mascara!
                 ])
            
            do {
                let rowId = try DB.run(update)
                guard rowId > 0 else {
                    
                    print(DataAccessError.Insert_Error)
                    throw DataAccessError.Insert_Error
                }
                print("registro creado en pivot table")
                return Int64(rowId)
            } catch _ {
                throw DataAccessError.Insert_Error
            }
            
            
            
        }
    }
    
    
    
    
    
    static func buscar(id: Int64) throws -> PGM? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(id == idgrupometodoid)
        let grupos =  try DB.prepare(query)
        for grupo in  grupos {
            
            
                   }
        
        return nil
        
    }
    
    static func ver() throws -> [PGM]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [GM]()
        let gms = try DB.prepare(table)
        for gm in gms {
            retArray.append(PivotGrupoMascaraModelo(
                idgrupo: gm[idgrupo],
                idmascara: gm[idmascara]
                
            ))
        }
        
        return retArray
        
    }
 
}

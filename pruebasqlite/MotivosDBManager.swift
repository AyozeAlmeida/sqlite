//
//  MotivosDBManager.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//
//
//  TeamDataHelper.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation

import SQLite


typealias MotivoModelo = (
    idMotivo: Int64?,
    idGrupo: Int64?,
    nombre: String?,
    letra: String?,
    numero: Int64?

)






class MotivoDBManager: CRUDProtocolo {
    
    
    
    
    static let TABLE_NAME = "MotivoBaliza"
    
    static let table = Table(TABLE_NAME)
    
    
    static let idMotivo = Expression<Int64>("idMotivo")
    static let idGrupo = Expression<Int64>("idGrupo")
    static let nombre = Expression<String>("nombre")
    static let letra = Expression<String>("letra")
    
    static let numero = Expression<Int64>("numero")
    
    
    
    
    
    
    
    typealias M = MotivoModelo
    
    
    
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
                table.column(idMotivo, primaryKey: true)
                table.column(idGrupo)
                table.column(nombre)
                table.column(letra)
                table.column(numero)
              
                print("tabla modelo creada con exito")            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insertar(item: M) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        print("entro en insertar")
        if (item.idMotivo != nil) {
            let insert = table.insert(idMotivo <- item.idMotivo!,
                                      idGrupo <- item.idGrupo!,
                                      nombre <- item.nombre!,
                                      letra <- item.letra!,
                                      numero <- item.numero!

            )
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
        if let id = item.idMotivo {
            let query = table.filter(idMotivo == id)
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
        
        let query = table.filter(item.idMotivo! == idMotivo)
      
        
        do {
            let update = query.update([idMotivo <- item.idMotivo!,
                                       idGrupo <- item.idGrupo!,
                                       nombre <- item.nombre!,
                                       letra <- item.letra!,
                                       numero <- item.numero!

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
        let query = table.filter(id == idMotivo)
        let motivos =  try DB.prepare(query)
        for motivo in  motivos {
            
            return MotivoModelo(
                idMotivo: motivo[idMotivo],
                idGrupo: motivo[idGrupo],
                nombre: motivo[nombre] ,
                letra: motivo[letra],
                numero: motivo[numero]

            )
            
        }
        
        return nil
        
    }
    
    static func ver() throws -> [M]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [B]()
        let Motivos = try DB.prepare(table)
        for motivo in Motivos {
            retArray.append(MotivoModelo(
                idMotivo: motivo[idMotivo],
                idGrupo: motivo[idGrupo],
                nombre: motivo[nombre],
                letra: motivo[letra],
                numero: motivo[numero]
                
            ))
        }
        
        return retArray
        
    }
}

//
//  TeamDataHelper.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 10/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation

import SQLite


typealias BalizaModelo = (
    idNS: Int64?,
    nombre: String?,
    idMaquina: Int64?,
    idMaquinaLogica: Int64?,
    idGMantes: Int64?,
    idGMdentro: Int64?,
    idGMdespues: Int64?,
    fechorDesde: Int64?,
    fechorHasta: Int64?,
    idGMidantes: Int64?,
    idGMiddentro: Int64?,
    idGMiddespues: Int64?
)






class BalizasDBManager: CRUDProtocolo {
    
    
    
    
    static let TABLE_NAME = "NSBaliza"
    
    static let table = Table(TABLE_NAME)
  
    
    static let idNS = Expression<Int64>("idNS")
    static let nombre = Expression<String>("nombre")
    static let idMaquina = Expression<Int64>("idMaquina")
    static let idMaquinaLogica = Expression<Int64>("idMaquinaLogica")
    
    static let idGMantes = Expression<Int64>("idGMantes")
    
    static let idGMdentro = Expression<Int64>("idGMdentro")
    
    static let idGMdespues = Expression<Int64>("idGMdespues")
    
    static let fechorDesde = Expression<Int64>("fechorDesde")
    static let fechorHasta = Expression<Int64>("fechorHasta")
    
    
    static let idGMidantes = Expression<Int64>("idGMidantes")
    
    static let idGMiddentro = Expression<Int64>("idGMiddentro")
    
    static let idGMiddespues = Expression<Int64>("idGMiddespues")
    
    
    
    
    
    
    typealias B = BalizaModelo
    
    
    
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
                table.column(idNS, primaryKey: true)
                table.column(nombre)
                table.column(idMaquina)
                table.column(idMaquinaLogica)
                table.column(idGMantes)
                table.column(idGMdentro)
                table.column(idGMdespues)
                table.column(fechorDesde)
                table.column(fechorHasta)
                table.column(idGMidantes)
                table.column(idGMiddentro)
                table.column(idGMiddespues)
                print("tabla balizas creada con exito")            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insertar(item: B) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
       print("entro en insertar")
        if (item.idNS != nil) {
            let insert = table.insert(idNS <- item.idNS!,
                                      nombre <- item.nombre!,
                                      idMaquina <- item.idMaquina!,
                                      idMaquinaLogica <- item.idMaquinaLogica!,
                                      idGMantes <- item.idGMantes!,
                                      idGMdentro <- item.idGMdentro!,
                                      idGMdespues <- item.idGMdespues!,
                                      fechorDesde <- item.fechorDesde!,
                                      fechorHasta <- item.fechorHasta!,
                                      idGMidantes <- item.idGMidantes!,
                                      idGMiddentro <- item.idGMiddentro!,
                                      idGMiddespues <- item.idGMiddespues!
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
    
    static func borrar (item: B) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.idNS {
            let query = table.filter(idNS == id)
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
    
    
  

    
    
    static func actualizar(item: B)  throws -> Int64 {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let tablaFilter = table.filter(item.idNS! == idNS)
        //let balizas =  try DB.prepare(tablaFilter)
        
        do {
            
            let update = tablaFilter.update([idNS <- item.idNS!,
                                       nombre <- item.nombre!,
                                       idMaquina <- item.idMaquina!,
                                       idMaquinaLogica <- item.idMaquinaLogica!,
                                       idGMantes <- item.idGMantes!,
                                       idGMdentro <- item.idGMdentro!,
                                       idGMdespues <- item.idGMdespues!,
                                       fechorDesde <- item.fechorDesde!,
                                       fechorHasta <- item.fechorHasta!,
                                       idGMidantes <- item.idGMidantes!,
                                       idGMiddentro <- item.idGMiddentro!,
                                       idGMiddespues <- item.idGMiddespues!
                
                
                
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
    
    

    
    
    static func buscar(id: Int64) throws -> B? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(id == idNS)
        let balizas =  try DB.prepare(query)
        for baliza in  balizas {
            
            return BalizaModelo(
                          idNS: baliza[idNS],
                          nombre: baliza[nombre],
                          idMaquina: baliza[idMaquina] ,
                          idMaquinaLogica: baliza[idMaquinaLogica],
                          idGMantes: baliza[idGMantes] ,
                          idGMdentro : baliza[idGMdentro] ,
                          idGMdespues: baliza[idGMdespues] ,
                          fechorDesde: baliza[fechorDesde] ,
                          fechorHasta: baliza[fechorHasta] ,
                          idGMidantes: baliza[idGMidantes] ,
                          idGMiddentro: baliza[idGMiddentro] ,
                          idGMiddespues: baliza[idGMiddespues]
                
                            
            
            )

        }
        
        return nil
        
    }
    
    static func ver() throws -> [B]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [B]()
        let balizas = try DB.prepare(table)
        for baliza in balizas {
            retArray.append(BalizaModelo(
                idNS: baliza[idNS],
                nombre: baliza[nombre],
                idMaquina: baliza[idMaquina],
                idMaquinaLogica: baliza[idMaquinaLogica],
                idGMantes: baliza[idGMantes] ,
                idGMdentro : baliza[idGMdentro] ,
                idGMdespues: baliza[idGMdespues] ,
                fechorDesde: baliza[fechorDesde] ,
                fechorHasta: baliza[fechorHasta] ,
                idGMidantes: baliza[idGMidantes] ,
                idGMiddentro: baliza[idGMiddentro] ,
                idGMiddespues: baliza[idGMiddespues]
            
            
            ))
        }
        
        return retArray
        
    }
}

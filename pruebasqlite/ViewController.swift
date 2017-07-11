//
//  ViewController.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 5/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do{
            try SQLiteDataStore().createTables()
            print("Tablas creadas con exito")
        }
        catch {
            print("error al crear las tablas");
        }
        
        
        
        let item = BalizaModelo(
            idNS: 056566556325656484, nombre: "bALIZA 1", idMaquina: 0, idMaquinaLogica: 0, idGMantes: 7, idGMdentro: 0, idGMdespues: 0, fechorDesde: 0, fechorHasta: 0, idGMidantes: 0, idGMiddentro: 0, idGMiddespues: 0
        )
        let item2 = BalizaModelo(
            idNS: 0565665563256564844, nombre: "bALIZA 1", idMaquina: 0, idMaquinaLogica: 0, idGMantes: 0, idGMdentro: 0, idGMdespues: 0, fechorDesde: 0, fechorHasta: 0, idGMidantes: 0, idGMiddentro: 0, idGMiddespues: 0
        )
        let itemMotivo = MotivoModelo(idMotivo: 44, idGrupo: 2, nombre: "eeee", letra: "roi", numero:  2)
        var array : [BalizaModelo]=[]
        array.append(item)
        array.append(item2)
        for item in array {
            do {
                // DECODE JSON == BALIZA MODELO
                
                
                
                let balizaId = try BalizasDBManager.insertar(
                    item: item )
                print("El siguiente registro se ha creado con exito: ")
                print(balizaId)
                
                print("Las balizas de la tabla son....")

                
                
                //try BalizasDBManager.borrarTabla(nombreTabla: "NSBaliza")
                
                
            } catch _{}
        }
        do {
            let item = BalizaModelo(
                idNS: 056566556325656484, nombre: "bALIZA 2", idMaquina: 0, idMaquinaLogica: 0, idGMantes: 7, idGMdentro: 0, idGMdespues: 0, fechorDesde: 0, fechorHasta: 0, idGMidantes: 0, idGMiddentro: 0, idGMiddespues: 0
            )
            try BalizasDBManager.actualizar(item: item)
            let retArray = try BalizasDBManager.ver()
            for item in retArray! {
                print(item)
            }
        } catch _ {}
        do {

            try MotivoDBManager.actualizar(item: itemMotivo)
        } catch _{
            print("ERROR EN MOTIVO ACTUALIZAR")
        }
        
        do {
            
            let motivoId = try MotivoDBManager.insertar(item: itemMotivo)
            print ("idMotivo",motivoId)

        } catch _{}
        do {
           let motivoArray = try MotivoDBManager.ver()
            for item in motivoArray!{
                print ("motivo",item)
            }
            
        } catch _{}
        
        //*********************** PRUEBAS MASCARAS *********************//
        
        do {
            let itemMascara = MascaraModelo(mascaraid: 10, mascarapermiso: 548)
            let mascaraId = try MascarasDBManager.insertar(item: itemMascara)
            print(mascaraId)
        } catch  _{
            print("error al intentar insertar en mascaras")
        }
        
               do {
            let itemMascara = MascaraModelo(mascaraid: 10, mascarapermiso: 1111)
            let mascaraId = try MascarasDBManager.actualizar(item: itemMascara)
            print("he actualizado")
            
        } catch  _{
            print("error al intentar actualizar en mascaras")
        }
       
        //*********************** PRUEBAS GRUPOS *********************//
        
        do {
            let itemGrupoPivot = PivotGrupoMascaraModelo(idgrupo: 3, idmascara: 0)
            let idgrupo = try GrupoMascaraDBManager.insertar(item: itemGrupoPivot)
            print(idgrupo)
        } catch  _{
            print("error al intentar insertar en grupos")
        }
        
        
        do {
            let itemGrupo = PivotGrupoMascaraModelo(idgrupo: 1, idmascara: 6)
            let grupoid = try GrupoMascaraDBManager.actualizar(item: itemGrupo)
            print("he actualizado mascara y grupo" )
            print(grupoid)
            
        } catch  _{
            print("error al intentar actualizar en mascaraygrupo")
        }
        
        

    
    
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


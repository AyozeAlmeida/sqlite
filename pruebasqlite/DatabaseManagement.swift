//
//  DatabaseManagement.swift
//  pruebasqlite
//
//  Created by Loquat Solutions on 5/7/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
import SQLite


class DatabaseManagement {
    

    static let shared:DatabaseManagement = DatabaseManagement()
    private var db:Connection?
    
    private let tblBaliza = Table("baliza")
    private let id = Expression<Int64>("id")
    private let name = Expression<String?>("name")
    private let imageName = Expression<String>("imageName")
    
 
    
    public init(){
    
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        print("\(path)")

        
        do{
            db = try Connection("\(path)/pruebaa.sqlite")
            
            let tblProduct = Table("product")
            
            try db!.run(tblProduct.drop(ifExists: true))
                
                print ("enable")
            createTableProduct()
            let baliza = Baliza(id: 7, name: "JJJJ", imageName: "IMAGEN")
            let baliza2 = Baliza(id: 7, name: "uuuu", imageName: "IMAGENotra")
            let insert = tblBaliza.insert(name <- baliza.name, imageName <- baliza.imageName)
            let id = try db!.run(insert)
            
            updateContact(productId: 3, newProduct: baliza2)
            
            //deleteProduct(inputId: 1)
            
            queryAllProduct()
            
        }catch {
            db = nil
            print ("Unable to open database")
        }
        
    }
    
    func createTableProduct() {
        do {
            try
                
                db!.run(tblBaliza.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
               
                table.column(imageName)
                print("create table successfully")
            })
            
        } catch {
            print("Unable to create table")
        }
    }
    
    
    func addProduct(inputName: String, inputImageName: String) -> Int64? {
        do {
            let insert = tblBaliza.insert(name <- inputName, imageName <- inputImageName)
            let id = try db!.run(insert)
            print("Insert to tblProduct successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllProduct() -> [Baliza] {
        var products = [Baliza]()
        
        do {
            for product in try db!.prepare(self.tblBaliza) {
                let newProduct = Baliza(id: product[id],
                                         name: product[name] ?? "",
                                         imageName: product[imageName])
                products.append(newProduct)
            }
        } catch {
            print("Cannot get list of product")
        }
        for product in products {
            print("each product = \(product)")
        }
        return products
    }
    
    func updateContact(productId:Int64, newProduct: Baliza) -> Bool {
        let tblFilterProduct = tblBaliza.filter(id == productId)
        do {
            let update = tblFilterProduct.update([
                name <- newProduct.name,
                imageName <- newProduct.imageName
                ])
            if try db!.run(update) > 0 {
                print("Update contact successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    func deleteProduct(inputId: Int64) -> Bool {
        do {
            let tblFilterProduct = tblBaliza.filter(id == inputId)
            try db!.run(tblFilterProduct.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
 
    
}



    

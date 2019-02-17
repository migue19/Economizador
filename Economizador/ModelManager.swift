//
//  ModelManager.swift
//  DBSuprema
//
//  Created by miguel mexicano on 26/12/15.
//  Copyright © 2015 ilab. All rights reserved.
//

import UIKit
let sharedInstance = ModelManager()
class ModelManager: NSObject {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Utility.getPath("EconomizadorDB.sqlite"))
        }
        return sharedInstance
    }
    
    
    
    
    
 ///Metodos de Ingresos
    /*func updateProductData(IngresosInfo: Ingresos) -> Bool {
        print("estoy updateando")
       
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Productos SET NombreP=?, ImagenP=?, Precio=?, DescripcionP=?, idTipoPro=?WHERE idProductos=?", withArgumentsInArray: [ProductInfo.NombreP, ProductInfo.ImagenP, ProductInfo.Precio,ProductInfo.DescripcionP, ProductInfo.idTipoPro, ProductInfo.idProductos])
        sharedInstance.database!.close()
        return isUpdated
    }*/
    
    
    func deleteIngreso(_ IngresosInfo: Ingresos) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Ingresos WHERE idIngresos=?", withArgumentsIn: [IngresosInfo.idIngresos])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    
    func addIngreso(_ Cantidad: Double, Fecha: String) -> Bool
    {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Ingresos(Cantidad,Fecha) VALUES (?,?)", withArgumentsIn: [Cantidad,Fecha])
        sharedInstance.database!.close()
        return isInserted
    }
    
    
    func getAllData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Ingresos", withArgumentsIn: nil)
        let marrIngresosInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let IngresosInfo : Ingresos = Ingresos()
                IngresosInfo.idIngresos = Int(resultSet.int(forColumn: "idIngresos"))
                IngresosInfo.Cantidad = Double(resultSet.string(forColumn: "Cantidad"))!
                IngresosInfo.Fecha = resultSet.string(forColumn: "Fecha")
                marrIngresosInfo.add(IngresosInfo)
            }
        }
        sharedInstance.database!.close()
        return marrIngresosInfo
    }
    
    
}

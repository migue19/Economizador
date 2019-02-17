//
//  Utility.swift
//  DBSuprema
//
//  Created by miguel mexicano on 26/12/15.
//  Copyright © 2015 ilab. All rights reserved.
//

import UIKit

class Utility: NSObject {
    class func getPath(_ fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    
    class func copyFile(_ fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            
            if (error != nil) {
              print("Error al Copiar la base: \(error!)")
            
            } else {
              print("Base Copiada Correctamente")
              
            }
        }
    }
    
    
    
    class func invokeAlertMethod(_ strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
       /* let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButtonWithTitle("Ok")
        alert.show()*/
    }
    
    
    class func crearAlerta(_ ViewController: UIViewController, titulo: String, mensaje: String)
    {
    
        let alert = UIAlertController(title:titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
            ViewController.present(alert, animated: true, completion: nil)
        
        
    }
   

}

//
//  ViewController.swift
//  Economizador
//
//  Created by miguel mexicano on 31/05/16.
//  Copyright © 2016 apperture. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource,AgregarIngresoProtocol {
    
    //Protocol
    var delegate: AgregarIngresoProtocol? = nil
    //Protocol
    
    var contador = 1
    let imagePicker = UIImagePickerController()
    let paths          : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let fileManager             = FileManager.default
    var refreshControl: UIRefreshControl!
    
    var marrIngresos: NSMutableArray = NSMutableArray()
    
    
    @IBOutlet weak var ImageTermometro: UIImageView!
    @IBOutlet weak var btnIngreso: UIButton!
    @IBOutlet weak var VistaTermometro: UIView!
    @IBOutlet weak var btnPerfil: UIButton!
    @IBOutlet weak var tablaIngresos: UITableView!
    @IBOutlet weak var Estado: UILabel!
    @IBOutlet weak var lblIngresoPromedio: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //image picker nos va a servir para poder acceder a la camara y a la bliblioteca de imagenes
        imagePicker.delegate = self
        //Cargar datos en la tabla
        marrIngresos = ModelManager.getInstance().getAllData()
//////Codigo para El Pull to Refresh//////////
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Actualizando", attributes: [NSForegroundColorAttributeName: UIColor.white])
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tablaIngresos.addSubview(refreshControl)
//////Fin Codigo para El Pull to Refresh//////////
        
/////Codigo Boton Delete con el Swipe dentro de la celda////////
        tablaIngresos.allowsMultipleSelectionDuringEditing = false;
/////Fin Codigo Boton Delete con el Swipe dentro de la celda////////
        
//Fondos Vista Principal
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fondo.jpg")!)
        VistaTermometro.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        tablaIngresos.backgroundColor = UIColor(patternImage: UIImage(named: "fondo.jpg")!)
//Fin Fondos
//Redondear las vistas y botones
        RedondearBorde(btnIngreso, borde: 2, color: UIColor.white, division: 4)
        RedondearVista(VistaTermometro, borde: 2, color: UIColor.white, division: 16)
        RedondearBorde(btnPerfil, borde: 4, color: UIColor.white, division: 2)
        RedondearVista(tablaIngresos, borde: 1, color: UIColor.white, division: 16)
//Fin Redondear las vistas y botones
//Guardar la imagen Localmente para que no se pierda al cerrar la aplicacion
        //Si existe la imagen asignarla como foto de perfil
        let getImagePath = (paths as NSString).appendingPathComponent("perfil.jpg")
        //print(getImagePath)
        
        if (fileManager.fileExists(atPath: getImagePath))
        {
            let imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
            btnPerfil.setImage(imageis, for: UIControlState())
        }
   //Fin Guardar la imagen Localmente para que no se pierda al cerrar la aplicacion
      if marrIngresos.count > 2
      {
      IngresoPromedio()
       }
     
    }//Fin ViewDidload()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
  
    //Funcion Pull to Refresh para Actualizar la tabla
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
     marrIngresos = []
     marrIngresos = ModelManager.getInstance().getAllData()
     tablaIngresos.reloadData()
      ocultarTable()
      desocultarTable()
    refreshControl.endRefreshing()
    }
    
    //required delegate func
    func actualizarTabla(){
        marrIngresos = []
        marrIngresos = ModelManager.getInstance().getAllData()
        tablaIngresos.reloadData()
        ocultarTable()
        desocultarTable()
        
        
        if marrIngresos.count > 1
        {
        IngresoPromedio()
        }
    }
    
    
    func IngresoPromedio()
    {
     var ingresopromedio = 0.0
     var numelemtos=0
     var ingreso = 0.0
        
        for index in 0..<marrIngresos.count-1
        {
        let ingresoobj:Ingresos = marrIngresos.object(at: index) as! Ingresos
        ingresopromedio += ingresoobj.Cantidad
         
        numelemtos = index
       }
        
        let ultimoobj:Ingresos = marrIngresos.object(at: numelemtos+1) as! Ingresos
        
        ingreso = ultimoobj.Cantidad
        print("El ingreso es: \(ingreso)")
        
     
        print("el total es: \(ingresopromedio)")
        print("numero de elementos es: \(numelemtos+1)")
        
        ingresopromedio = ingresopromedio/Double(numelemtos+1)
        
        print("El ingreso promedio es: \(ingresopromedio)")
        
        
        lblIngresoPromedio.text = "INGRESO PROMEDIO: $\(round(1000*ingresopromedio)/1000)    INGRESO: $\(ingreso)"
        
        
        // se divide entre 6 por que son las 6 etapas del termometro
        let divisioningreso = ingresopromedio/6.0
        
        
        if ingreso >= divisioningreso*6
        {
            ImageTermometro.image = UIImage(named: "Termometro-0")
            Estado.text = "😄 VAS MUY BIEN: tu ingreso es superior al promedio"
            print("Tu ingreso es superior al promedio")
        }
        
        //Tienes mas de 5/6 del saldo promedio
        if ingreso < divisioningreso*6 && ingreso >= divisioningreso*5
        {
            ImageTermometro.image = UIImage(named: "Termometro-1")
            Estado.text = "😅 NO TE PREOCUPES: echale mas ganas"
            print("Tu ingreso es mayor igual a 5/6 del saldo promedio")

        }
        if ingreso < divisioningreso*5 && ingreso >= divisioningreso*4
        {
            ImageTermometro.image = UIImage(named: "Termometro-2")
            Estado.text = "🤗 HUY ANDAMOS UN POCO MAL: Esfuerzate más"
            print("Tu ingreso es mayor igual a 4/6 del saldo promedio")
        }
        if ingreso < divisioningreso*4 && ingreso >= divisioningreso*3
        {
            ImageTermometro.image = UIImage(named: "Termometro-3")
            Estado.text = "🤔 TENEMOS UNA MALA RACHA: Pasara pronto ¡Vamos!"
            print("Tu ingreso es mayor igual a 3/6 del saldo promedio")
        }
        if ingreso < divisioningreso*2 && ingreso >= divisioningreso*1
        {
            ImageTermometro.image = UIImage(named: "Termometro-4")
            Estado.text = "😠 ESTAMOS MAL: Esfuerzate ¡Trabaja más!"
            print("Tu ingreso es mayor igual a 2/6 del saldo promedio")
        }
        if ingreso < divisioningreso*1 && ingreso >= divisioningreso*0
        {
            ImageTermometro.image = UIImage(named: "Termometro-5")
            Estado.text = "😡 QUE PASA CONTIGO : ¡Estamos muy mal"
            print("Tu ingreso es mayor igual a 1/6 del saldo promedio")
        }
        
        
        
    
    }
    
    
    
    
    
   ///////Codigo para animar las celdas dentro del tableview
    func ocultarTable(){
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.3
        tablaIngresos.layer.add(animation, forKey: nil)
        tablaIngresos.layer.add(animation, forKey: nil)
        
        tablaIngresos.isHidden = true
    }
    
    func desocultarTable(){
        animateTable()
        tablaIngresos.isHidden = false
    }
    
    func animateTable() {
        //tableViewIE.reloadData()
        
        let cells = tablaIngresos.visibleCells
        let tableHeight: CGFloat = tablaIngresos.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.3, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    ///////Fin Codigo para animar las celdas dentro del tableview
 
    

    @IBAction func PonerIngreso(_ sender: AnyObject) {
        /*let nombreimage = "Termometro-"+String(contador)
        ImageTermometro.image = UIImage(named: nombreimage)
        contador += 1
        
        if contador == 6
        {
        contador=0
        }*/
    
        performSegue(withIdentifier: "hola", sender: self)
        
    }
    
    
///////Funcion para poner un Borde con las esquinas redondas en los botones
    func RedondearVista(_ objeto:UIView,borde: Double,color: UIColor,division: Int)
    {
        objeto.layer.borderWidth = CGFloat(borde)
        objeto.layer.masksToBounds = false
        objeto.layer.borderColor = color.cgColor
        objeto.layer.cornerRadius = objeto.frame.size.height/CGFloat(division)
        objeto.clipsToBounds = true
        
    }
    func RedondearBorde(_ objeto:UIButton,borde: Double,color: UIColor,division: Int)
    {
        objeto.layer.borderWidth = CGFloat(borde)
        objeto.layer.masksToBounds = false
        objeto.layer.borderColor = color.cgColor
        objeto.layer.cornerRadius = objeto.frame.size.height/CGFloat(division)
        objeto.clipsToBounds = true
    }
///////Funcion para poner un Borde con las esquinas redondas en los botones
    
    
//Funcion que ejecuta el pop over para elegir la opcion para el uiimagepicker(foto,galeria)
    @IBAction func cambiarFotoPerfil(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        
        let alertController = UIAlertController(title: "Escoger Imagen", message: "Seleccione una opcion", preferredStyle: .actionSheet)
        
        
        let camara = UIAlertAction(title: "Tomar una Foto", style: .default, handler: { (action) -> Void in
         self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
         })
        alertController.addAction(camara)
        
        let galeria = UIAlertAction(title: "Seleccionar de la Galeria", style: .default, handler: { (action) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
            })
        alertController.addAction(galeria)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alertController.addAction(cancelar)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Guardar la imagen seleccionada dentro de los archivos de la aplicacion
            let filePathToWrite = "\(self.paths)/perfil.jpg"
            //print("Ruta de la imagen: \(filePathToWrite)")
            let jpgImageData = UIImageJPEGRepresentation(pickedImage, 1.0)
            self.fileManager.createFile(atPath: filePathToWrite, contents: jpgImageData, attributes: nil)
            
            btnPerfil.contentMode = .scaleAspectFill
            btnPerfil.setImage(pickedImage, for: UIControlState())
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }

//Fin Funcion que ejecuta el pop over para elegir la opcion para el uiimagepicker(foto,galeria)
  
    
      //MARK: - TABLEVIEWCONTROLLER DELEGATE METHODS
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return marrIngresos.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:UITableViewCell = self.tablaIngresos.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            
            let cellingresos: Ingresos = marrIngresos.object(at: indexPath.row) as! Ingresos
            
            
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = cellingresos.Fecha
            cell.detailTextLabel?.text = "$"+String(cellingresos.Cantidad)
            
            return cell
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
  //////Funcion para poner el boton de Delete con el Swipe dentro de la celda
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
           let cellingresos: Ingresos = marrIngresos.object(at: indexPath.row) as! Ingresos
            if(!ModelManager.getInstance().deleteIngreso(cellingresos)){
                print("Error al eliminar ingreso")
            }
            
            marrIngresos = []
            marrIngresos = ModelManager.getInstance().getAllData()
            tablaIngresos.reloadData()
            ocultarTable()
            desocultarTable()
            
            if marrIngresos.count > 2
            {
                IngresoPromedio()
            }
            else
            {
              Estado.text = "ESTADO"
              ImageTermometro.image = UIImage(named: "Termometro-0")  
            }
        
        }
    }
  //////Funcion para poner el boton de Delete con el Swipe dentro de la celda
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Protocol
        if segue.identifier == "hola"{
            print("enviado delegado")
            let vd = segue.destination as! AgregarIngresoViewController
            vd.delegate = self
        }
   
    }
    

}


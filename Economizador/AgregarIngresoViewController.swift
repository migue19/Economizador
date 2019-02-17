//
//  AgregarIngresoViewController.swift
//  Economizador
//
//  Created by miguel mexicano on 01/06/16.
//  Copyright © 2016 apperture. All rights reserved.
//

//Protocol
protocol AgregarIngresoProtocol{
    func actualizarTabla()
}
//Protocol

import UIKit

class AgregarIngresoViewController: UIViewController, UIViewControllerTransitioningDelegate {
    //Protocol
    var delegate: AgregarIngresoProtocol? = nil
    //Protocol
    
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var btncerrar: UIButton!
    @IBOutlet weak var lblFecha: UITextField!
    @IBOutlet weak var lblCantidad: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        RedondearBordeView(viewMain, borde: 2, color: .white, division: 16)
        RedondearBorde(btnRegistrar, borde: 2, color: UIColor.white, division: 4)
        RedondearBorde(btncerrar, borde: 4, color: UIColor.white, division: 2)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-YYYY HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        
        lblFecha.text = strDate
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func RedondearBordeView(_ objeto:UIView,borde: Double,color: UIColor,division: Int)
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

    @IBAction func Cerrar(_ sender: AnyObject) {
        if (delegate != nil) {
            delegate?.actualizarTabla()
        }
        presentingViewController!.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func Registrar(_ sender: AnyObject) {
        
       if let Cantidad: Double = Double(lblCantidad.text!)
       {
         let Fecha = lblFecha.text!
        
        
        
        if(!ModelManager.getInstance().addIngreso(Cantidad,Fecha: Fecha)){
            print("Error al agregar ingreso")
        }
        
          if (delegate != nil) {
            delegate?.actualizarTabla()
           }
          presentingViewController!.dismiss(animated: true, completion: nil)
        
        }
       else
       {
        let alert = UIAlertController(title: "Mensaje de Error", message: "Proporcione valores validos", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    
    // Subvista Custom Modal

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    
    // ---- UIViewControllerTransitioningDelegate methods
    
    /*func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return nil
    }*/
    
    /*func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }*/
    
    /*func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }*/

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  pinterest
//
//  Created by Alumno IDS on 22/02/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        //add subview
        view.addSubview(inputContainerView)
        view.addSubview(firstButton)
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(passwordTextField)
        
        
        //constraints
        // constraints for input
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        
        
        
        firstButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        firstButton.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.backgroundColor = .white
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name"
        tf.backgroundColor = .white
        return tf
    }()
    
    let inputContainerView : UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let firstButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor =  UIColor(r: 235, g: 101, b: 90)
        ub.setTitle("Registrarse", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
    
    @objc func handleButton(){
        print("Hola Mundo")
        if let email = emailTextField.text, let pass = passwordTextField.text, let name = nameTextField.text{
            print(email)
            print(pass)
            Auth.auth().createUser(withEmail: email, password: pass) { (data:AuthDataResult?, error) in
                let user = data?.user
                if error != nil {
                    print(error.debugDescription)
                }
                
                let ref = Database.database().reference(fromURL: "https://pinterest-mrdl98.firebaseio.com")
                
                if let uid = user?.uid{
                    
                    let usersRef = ref.child("users").child(uid)
                    usersRef.updateChildValues(["name" : name, "email" : email, "password": pass])
                    
                    let msgsRef = ref.child("message").child(uid)
                    msgsRef.updateChildValues(["message" : "Prueba"])
                    
                    ref.child("message").child(uid).removeValue()
                    
                }
            }
        }
    }
    
}

extension UIColor {
    
    convenience init(r:CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

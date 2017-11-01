//
//  LogInController.swift
//  GameOfChats
//
//  Created by Nulrybek Karshyga on 24.10.17.
//  Copyright © 2017 Nulrybek Karshyga. All rights reserved.
//

import UIKit
import Firebase

class LogInController: UIViewController {
    
    let inputContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    //Registration button
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        } else {
            handleRegistration()
        }
    }
    
    func handleLogin() {
        guard let email = emailFieldText.text, let password = passwordFieldText.text else{
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            //aumtomatil log out
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    var ref: DatabaseReference!
    
    @objc func handleRegistration() {
        
        guard let email = emailFieldText.text, let password = passwordFieldText.text, let name = nameFieldText.text else{
            print("Form is not valid")
            return
        }
        
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error!)
                    return
                }
                guard let uid = user?.uid else {
                    return
                }
            
                let ref = Database.database().reference(fromURL: "https://facebookmassaging.firebaseio.com/")
                let usersReference = ref.child("users").child(uid)
                let values = ["name": name,"email": email ]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err!)
                        return
                    }
                })
                
            })
        }

    
    
    let nameFieldText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailFieldText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordFieldText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageVieew: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LounchIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @objc func handleSelectProfileImageView() {
        print("Works")
    }
    
    lazy var loginRegisterSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Registration"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        //CHANGE TITLE FOR THE REGISTER BUTTON
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        nameTextFieldHieghtAnchor?.isActive = false
        nameTextFieldHieghtAnchor = nameFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor , multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHieghtAnchor?.isActive = true
        //HIDE NAMEFIELDTEXT
        nameTextFieldHieghtAnchor?.isActive = false
        nameTextFieldHieghtAnchor = nameFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor , multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHieghtAnchor?.isActive = true
        //EXTEND EMAILTEXTFIELD
        emailTextFieldHieghtAnchor?.isActive = false
        emailTextFieldHieghtAnchor = emailFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHieghtAnchor?.isActive = true
        //EXTEND PASSWORDTEXTFIELD
        passwordTextFieldHieghtAnchor?.isActive = false
        passwordTextFieldHieghtAnchor = passwordFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHieghtAnchor?.isActive = true
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)

        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageVieew)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainer()
        setLoginRegisterButton()
        setProfileImageView()
        setLoginRegisterSegmentedControl()
    }
    
    func setLoginRegisterSegmentedControl() {
        //need  x, y, width , height
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.centerYAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -40).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    func setProfileImageView() {
        //need  x, y, width , height
        profileImageVieew.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageVieew.centerYAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -90).isActive = true
        profileImageVieew.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageVieew.heightAnchor.constraint(equalToConstant:  150).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHieghtAnchor: NSLayoutConstraint?
    var emailTextFieldHieghtAnchor: NSLayoutConstraint?
    var passwordTextFieldHieghtAnchor: NSLayoutConstraint?

    
    func setupInputsContainer() {
        //need  x, y, width , height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameFieldText)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailFieldText)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordFieldText)
    //NAME
        //need  x, y, width , height
        nameFieldText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameFieldText.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameFieldText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHieghtAnchor = nameFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHieghtAnchor?.isActive = true
        //need  x, y, width , height
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameFieldText.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    //EMAIL
        //need  x, y, width , height
        emailFieldText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailFieldText.topAnchor.constraint(equalTo: nameFieldText.bottomAnchor).isActive = true
        emailFieldText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHieghtAnchor = emailFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHieghtAnchor?.isActive = true
        
        //need  x, y, width , height
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailFieldText.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    //PASSWORD
        
        //need  x, y, width , height
        passwordFieldText.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordFieldText.topAnchor.constraint(equalTo: emailFieldText.bottomAnchor).isActive = true
        passwordFieldText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHieghtAnchor = passwordFieldText.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHieghtAnchor?.isActive = true
    }
    
    func setLoginRegisterButton() {
         //need  x, y, width , height
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat,b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

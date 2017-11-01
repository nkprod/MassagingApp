//
//  ViewController.swift
//  GameOfChats
//
//  Created by Nulrybek Karshyga on 24.10.17.
//  Copyright © 2017 Nulrybek Karshyga. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "newMessage")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLogedIn()
        }
    
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLogedIn() {
            if Auth.auth().currentUser?.uid == nil {
                //if user is not logged than perform handleLogout
                perform(#selector(handleLogout), with: nil, afterDelay: 0)
            } else {
                let uid  = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        self.navigationItem.title = dictionary["name"] as? String
                        
                    }
                }, withCancel: nil)
            }
        
        
    }
    @objc func handleLogout() {
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LogInController()
        present(loginController, animated: true, completion: nil)
        
        
    }


}


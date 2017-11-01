//
//  NewMessageController.swift
//  GameOfChats
//
//  Created by Nulrybek Karshyga on 27.10.17.
//  Copyright © 2017 Nulrybek Karshyga. All rights reserved.
//

import UIKit
import Firebase
class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let userDict = User()
                userDict.name = dictionary["name"] as? String
                userDict.email = dictionary["email"] as? String
                self.users.append(userDict)
                self.tableView.reloadData()
                
            }
        }, withCancel: nil )
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

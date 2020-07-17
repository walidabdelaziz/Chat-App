//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Walid  on 7/13/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    
    var messages: [Message] = []
    let db = Firestore.firestore()

    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        
        // Register Nib to TableView
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        
        // load messages to table view
        
        loadMessages()
    }
    
    func loadMessages(){
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (snapshot, error) in
            self.messages = []
            if let err = error {
                print("There is an error:\(err)")
            } else {
                if let documentedData = snapshot?.documents {
                    for doc in documentedData {
                        let data = doc.data()
                        if let messagebody = data[K.FStore.bodyField] as? String , let messagesender = data[K.FStore.senderField] as? String {
                            let newMessage = Message(sender: messagesender, messagebody: messagebody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                            
                        self.tableView.reloadData()
                                
                                
                        // scroll to last message being sent
                        
                                let indexpath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexpath, at: .top, animated: false)

                            }
                        }
                    }
                }
            }
        }
        
        
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messagebody = messageTextField.text, let messagesender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.bodyField : messagebody,
                K.FStore.senderField: messagesender,
                K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                    if let err = error {
                        print("There is an error:\(err)")
                    } else {
                        print("Message Sucessfully Saved")
                        DispatchQueue.main.async {
                            self.messageTextField.text = ""
                        }
                    }
            }
    }
    }

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
   
}
//MARK:- UITableViewDataSource

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.messagebody
        
        
        // if sender is the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        return cell
    }
    
    
}

//
//  AppInboxViewViewController.swift
//  TestHorse
//
//  Created by Daniel Bogdanov on 18.03.19.
//  Copyright © 2019 Daniel Bogdanov. All rights reserved.
//

import UIKit
import Leanplum

class AppInboxViewViewController: UITableViewController{

    let inbox: LPInbox = Leanplum.inbox()
    var unread: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       navigationItem.title = "Inbox"
        
    }
    
    func setUnread(){
        print(inbox.unreadCount)
        if(inbox.unreadCount > 0){
            self.unread = inbox.unreadCount
            
        }
    }
    
    func getUnread() -> Int {
        return Int(self.unread)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: UInt  = inbox.count()
        //let unreadCount: UInt = inbox.unreadCount
        return Int(count)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allMessages: [LPInboxMessage] = inbox.allMessages() as! [LPInboxMessage]
        let message: LPInboxMessage = allMessages[0]
        print("Message:")
        print(message.data())
//        print("Data:"\allMessages)
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = allMessages[indexPath.item].title()

        return cell
        
        
    }

}



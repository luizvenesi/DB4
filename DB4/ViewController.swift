//
//  ViewController.swift
//  DB4
//
//  Created by Luiz on 2017-10-08.
//  Copyright © 2017 Luiz Venesi. All rights reserved.
//

import UIKit
import Firebase

/////////////////// Convert to R$  ///////////////////////////
extension NumberFormatter {
    convenience init(style: Style) {
        self.init()
        numberStyle = style
    }
}

extension Formatter {
    static let currency = NumberFormatter(style: .currency)
    static let currencyUS: NumberFormatter = {
        let formatter = NumberFormatter(style: .currency)
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    static let currencyBR: NumberFormatter = {
        let formatter = NumberFormatter(style: .currency)
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
}


extension FloatingPoint {
    var currency: String {
        return Formatter.currency.string(for: self) ?? ""
    }
    var currencyUS: String {
        return Formatter.currencyUS.string(for: self) ?? ""
    }
    var currencyBR: String {
        return Formatter.currencyBR.string(for: self) ?? ""
    }
    
}
/////////////////// Convert to R$  ///////////////////////////

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    //Array storage all data from DB
    var messageArray : [Messages] = [Messages]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        TableView.delegate = self
        TableView.dataSource = self
        //Call functions
        configureTableView()
        retrieveMessages()
       
       
       
    }
    //Return all data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageArray.sort(by: {$0.totalYear > $1.totalYear})
        return messageArray.count
    }
    //Reatrive data on Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCell", owner: self, options: nil)?.first as! CustomCell
        cell.nameSenator.text = messageArray[indexPath.row].name
        cell.stateSenator.text = "Estado: \(messageArray[indexPath.row].state)"
        cell.partySenator.text = "\(messageArray[indexPath.row].party)"
        cell.imageURL.text = messageArray[indexPath.row].image
        cell.year.text = "\(messageArray[indexPath.row].year)"
        //Converto to R$ ///////////
        let price = messageArray[indexPath.row].totalYear
        Formatter.currency.locale = Locale(identifier: "pt_BR")
        cell.totalYear.text = price.currency
        
        cell.other.text = "\(messageArray[indexPath.row].theText)"
        cell.startSenator.text = "Mandato: \(messageArray[indexPath.row].start) - \(messageArray[indexPath.row].start + 8)"

        TableView.separatorStyle = .none
        cell.selectionStyle = .none
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 285
    }
    //Size Table View
    func configureTableView(){
        TableView.rowHeight = UITableViewAutomaticDimension
        TableView.estimatedRowHeight = 120.0
    }

    //Feach data
    func retrieveMessages(){
        
        let messageDB = FIRDatabase.database().reference().child("Senator").child("senators")
        messageDB.observe(.childAdded, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue!["name"] as? String
            let state = snapshotValue!["state"] as? String
            let party = snapshotValue!["party"] as? String
            let image = snapshotValue!["image"] as? String
            let year = snapshotValue!["year2017"] as? String
            let totalYear = snapshotValue!["total2017"] as? Float
            let start = snapshotValue!["start"] as? Int
            
           let paragraphDict = snapshotValue!["2017"] as! [String: AnyObject]
            let theText = paragraphDict["aluguelTotal"] as! String
           
            let message = Messages()
            message.name = name!
            message.state = state!
            message.party = party!
            message.image = image!
            message.year = year!
            message.totalYear = totalYear!
            message.start = start!
            message.theText = String(theText)

            self.messageArray.append(message)

            self.configureTableView()
            self.TableView.reloadData()

        })
       
    }
    
    
    
    
}
    
    
    
    



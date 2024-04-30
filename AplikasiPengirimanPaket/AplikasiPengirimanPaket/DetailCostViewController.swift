//
//  DetailCostViewController.swift
//  AplikasiPengirimanPaket
//
//  Created by Markus Nugraha on 14/10/23.
//

import UIKit

class DetailCostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Menyimpan hasil import segue dari ViewComtroller
    var importListResultCekCost: [ServiceDetails] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hasil Import: \(importListResultCekCost)")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return importListResultCekCost.count
    }
        
    // Set isi dari setiap cell tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! PrototypeCell
        
        let service = importListResultCekCost[indexPath.row].service
        cell.Service.text = "Service: \(service)"
        let desc = importListResultCekCost[indexPath.row].description
        cell.Description.text = "Description: \(desc)"
        let cost = importListResultCekCost[indexPath.row].costValue
        cell.CostValue.text = "Cost Value: \(cost)"
        let etd = importListResultCekCost[indexPath.row].description
        cell.ETD.text = "ETD: \(etd)"
            
        return cell
    }

}

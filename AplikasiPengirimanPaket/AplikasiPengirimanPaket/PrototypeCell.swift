//
//  PrototypeCell.swift
//  AplikasiPengirimanPaket
//
//  Created by Markus Nugraha on 14/10/23.
//

import UIKit

class PrototypeCell: UITableViewCell {
    
    // Ini untuk cell dari DetailCostViewController
    @IBOutlet weak var Service: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var CostValue: UILabel!
    @IBOutlet weak var ETD: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CellNote.swift
//  Notes
//
//  Created by user on 29.01.2024.
//

import UIKit

class CellNote: UITableViewCell {
    
    @IBOutlet var ImageSwitch: UIImageView!
    @IBOutlet var Lable: UILabel!
    @IBOutlet var LableInformation: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    

    
}

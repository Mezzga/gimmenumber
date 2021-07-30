//
//  ContactsCell.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 12/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var vw: UIView!
 @IBOutlet weak var btnShare: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

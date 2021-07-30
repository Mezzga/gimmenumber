//
//  CountryCell.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 13/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var cimg: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

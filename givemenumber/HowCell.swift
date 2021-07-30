//
//  HowCell.swift
//  givemenumber
//
//  Created by BlueGenie on 20/03/20.
//  Copyright © 2020 BGMacMIni2. All rights reserved.
//

import UIKit

class HowCell: UITableViewCell {
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblcontent: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  FilterShopTypeCell.swift
//  projecttokped
//
//  Created by mac on 15/06/19.
//  Copyright © 2019 ivan. All rights reserved.
//

import UIKit

class FilterShopTypeCell: UITableViewCell {
    
    @IBOutlet weak var tickView: UIView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

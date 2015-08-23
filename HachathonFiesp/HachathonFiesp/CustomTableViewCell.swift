//
//  CustomTableViewCell.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 22/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var image2: UIImageView!
    @IBOutlet var nome: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var area: UILabel!
    @IBOutlet var descricao: UILabel!
    @IBOutlet var tags: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.image2.layer.cornerRadius = self.image2.frame.size.height/2.0
        self.image2.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

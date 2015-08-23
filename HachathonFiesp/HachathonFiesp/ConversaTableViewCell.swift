//
//  ConversaTableViewCell.swift
//  HachathonFiesp
//
//  Created by William Alvelos on 23/08/15.
//  Copyright (c) 2015 William Alvelos. All rights reserved.
//

import UIKit

class ConversaTableViewCell: UITableViewCell {

    @IBOutlet var imagem: UIImageView!
    @IBOutlet var labelNome: UILabel!
    
    @IBOutlet var labelTags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

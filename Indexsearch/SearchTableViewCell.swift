//
//  SearchTableViewCell.swift
//  Indexsearch
//
//  Created by Aaron Wasserman on 7/20/15.
//  Copyright (c) 2015 Aaron Wasserman. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

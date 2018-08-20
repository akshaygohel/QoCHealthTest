//
//  AppListTableViewCell.swift
//  QOCTest
//
//  Created by Akshay Gohel on 2018-08-20.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import UIKit

class AppListTableViewCell: UITableViewCell {

    @IBOutlet weak var appIconImageView: QoCImageView!
    @IBOutlet weak var appTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func populateAppOnScreen(app:Application) {
        appTitleLabel.text = app.name ?? ""
        
        if let iconUrl = app.iconUrl {
            self.appIconImageView.fetchImageFrom(url: iconUrl)
        }
    }
}

//
//  DetailViewController.swift
//  QOCTest
//
//  Created by Akshay Gohel on 2018-08-19.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var appIconImageView: QoCImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var appStoreLinkButton: UIButton!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var otherAppsLinkButton: UIButton!
    
    var application: Application?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        cleanUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populateUI()
    }
    
    // MARK: - UI Processing Methods
    
    func cleanUpUI() {
        appNameLabel.text = " "
        self.appIconImageView.image = nil
        self.dateLabel.text = " "
        self.summaryLabel.text = " "
        self.priceLabel.text = " "
        self.categoryLabel.text = " "
        self.appStoreLinkButton.setTitle(" ", for: UIControlState.normal)
        self.publisherLabel.text = " "
        self.otherAppsLinkButton.setTitle(" ", for: UIControlState.normal)
    }
    
    func populateUI() {
        appNameLabel.text = application?.name ?? " "
        
        if let iconUrl = application?.iconUrl {
            self.appIconImageView.fetchImageFrom(url: iconUrl)
        }
        
        if let releaseDate = application?.releaseDate {
            self.dateLabel.text = CommonUtility.convertToUTC(dateToConvert: releaseDate, withFormat: "MM/dd/yyyy")
        }
        
        if let summary = application?.summary {
            self.summaryLabel.text = summary
        }
        
        if let price = application?.price {
            self.priceLabel.text = price
        }
        
        if let category = application?.category {
            self.categoryLabel.text = category
        }
        
        if let appStoreLink = application?.appStoreUrl {
            self.appStoreLinkButton.setTitle(appStoreLink, for: UIControlState.normal)
        }
        
        if let publisher = application?.publisher {
            self.publisherLabel.text = publisher
        }
        
        if let publisherLink = application?.publisherLink {
            self.otherAppsLinkButton.setTitle(publisherLink, for: UIControlState.normal)
        }
    }
    
    // MARK: - Button/Link Tapped

    @IBAction func otherAppsLinkTapped(_ sender: Any) {
        CommonUtility.tryOpeningUrl(urlString: self.otherAppsLinkButton.title(for: UIControlState.normal) ?? "")
    }
    
    @IBAction func appStoreLinkTapped(_ sender: Any) {
        CommonUtility.tryOpeningUrl(urlString: self.appStoreLinkButton.title(for: UIControlState.normal) ?? "")
    }
}

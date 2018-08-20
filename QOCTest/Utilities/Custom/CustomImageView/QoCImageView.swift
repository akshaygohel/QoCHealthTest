//
//  QoCImageView.swift
//  QOCTest
//
//  Created by Akshay Gohel on 2018-08-20.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import UIKit

class QoCImageView : UIImageView {
    var currentTask : URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
    
    func fetchImageFrom ( url urlString : String) {
        currentTask?.cancel()
        let url = URL(string: urlString)
        if let url = url {
            self.currentTask = URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) -> Void in
                DispatchQueue.main.async {
                    if let data = data {
                        self.image = UIImage(data: data)
                    }
                }
            })
            currentTask?.resume()
        }
    }
}

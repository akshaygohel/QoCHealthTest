//
//  CommonUtility.swift
//  QOCTest
//
//  Created by Akshay Gohel on 2018-08-20.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation
import UIKit

class CommonUtility {
    static func tryOpeningUrl(urlString : String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func convertToUTC(dateToConvert:String, withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: convertedDate!)
    }
}

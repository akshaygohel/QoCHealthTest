//
//  WebService.swift
//  QOCTest
//
//  Created by Akshay Gohel on 2018-08-20.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation

class WebService {
    func fetchDataFrom ( url urlString : String, completion : @escaping ( _ appArray : [Application]?, _ error : NSError? ) -> Void ) {
        if let url = URL(string: urlString) {
            let session = URLSession.shared;
            let loadTask = session.dataTask(with: url) { (data, response, error) in
                if let errorResponse = error {
                    completion(nil, errorResponse as NSError)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let errorResponse = NSError(domain: "Domain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "Http error occured"])
                        completion(nil, errorResponse)
                    } else {
                        let appsArray = self.parseResponse(data: data)
                        completion(appsArray, nil)
                    }
                }
            }
            loadTask.resume()
        }
    }
    
    private func parseResponse(data: Data?) -> [Application] {
        var applications = [Application]()
        
        if let data = data {
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:data, options: [])
                if let jsonDict =  jsonResponse as? NSDictionary {
                    guard let feed = jsonDict["feed"] as? NSDictionary else {
                        return applications
                    }
                    guard let entries = feed["entry"] as? Array<NSDictionary> else {
                        return applications
                    }
                    for entry in entries {
                        var appNameString : String?, imageUrlString : String?
                        if let appNameDict = entry["im:name"] as? NSDictionary {
                            if let appName = appNameDict["label"] as? String {
                                appNameString = appName
                            }
                        }
                        if let imageUrlArray = entry["im:image"] as? Array<NSDictionary> {
                            if let imageUrlDict = imageUrlArray.last, let imageUrl = imageUrlDict["label"] as? String {
                                imageUrlString = imageUrl
                            }
                        }
                        if let appName = appNameString, let imageUrl = imageUrlString {
                            let application = Application()
                            application.name = appName
                            application.iconUrl = imageUrl
                            
                            if let releaseDateDict = entry["im:releaseDate"] as? NSDictionary {
                                if let releaseDate = releaseDateDict["label"] as? String {
                                    application.releaseDate = releaseDate
                                }
                            }
                            
                            if let summaryDict = entry["summary"] as? NSDictionary {
                                if let summary = summaryDict["label"] as? String {
                                    application.summary = summary
                                }
                            }
                            
                            if let priceDict = entry["im:price"] as? NSDictionary {
                                if let priceAttributesDict = priceDict["attributes"] as? NSDictionary, let amount = priceAttributesDict["amount"] as? String, let currency = priceAttributesDict["currency"] as? String {
                                    let amt = String(format: "%0.2f", Float(amount) ?? 0.0)
                                    let price = "\(currency) \(amt)"
                                    application.price = price
                                } else if let price = priceDict["label"] as? String {
                                    application.price = price
                                }
                            }
                            
                            if let categoryDict = entry["category"] as? NSDictionary {
                                if let categoryAttributesDict = categoryDict["attributes"] as? NSDictionary, let category = categoryAttributesDict["label"] as? String {
                                    application.category = category
                                }
                            }
                            
                            if let idDict = entry["id"] as? NSDictionary {
                                if let link = idDict["label"] as? String {
                                    application.appStoreUrl = link
                                }
                            } else if let appStoreLinkDict = entry["link"] as? NSDictionary {
                                if let appStoreLinkAttributesDict = appStoreLinkDict["attributes"] as? NSDictionary, let link = appStoreLinkAttributesDict["href"] as? String {
                                    application.appStoreUrl = link
                                }
                            }
                            
                            if let artistDict = entry["im:artist"] as? NSDictionary {
                                if let artistName = artistDict["label"] as? String {
                                    application.publisher = artistName
                                }
                                
                                if let artistAttributesDict = artistDict["attributes"] as? NSDictionary, let link = artistAttributesDict["href"] as? String {
                                    application.publisherLink = link
                                }
                            }
                            
                            applications.append(application)
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        return applications
    }
}

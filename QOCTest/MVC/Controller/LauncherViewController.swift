//
//  LauncherViewController.swift
//  QOCTest
//
//  Created by Akshay Gohel on 2018-08-19.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import UIKit

class LauncherViewController: UIViewController {

    let urlString = "http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=100/json"
    
    @IBOutlet weak var tableView: UITableView!
    
    var appsArray : [Application] = []
    
    var isFetchedOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "QoC Health"
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pullTheDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Processing Methods
    
    func pullTheDataFromServer() {
        if !isFetchedOnce {
            isFetchedOnce = true
            WebService().fetchDataFrom(url: urlString) { [weak self] (apps, error) in
                if error != nil {
                    print("error occured: \(error!)")
                } else if let apps = apps {
                    self?.appsArray = apps
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndexPath = self.tableView.indexPathForSelectedRow
        if let indexPath = selectedIndexPath, let detailVC = segue.destination as? DetailViewController {
            let application = appsArray[indexPath.row]
            detailVC.application = application
        }
    }
}

extension LauncherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicationListCell", for: indexPath) as! AppListTableViewCell
        let application = appsArray[indexPath.row]
        cell.populateAppOnScreen(app: application)
        return cell
    }
}

extension LauncherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let application = appsArray[indexPath.row]
    }
}

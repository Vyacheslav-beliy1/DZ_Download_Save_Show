//
//  PostsTableViewController.swift
//  dz_l10
//
//  Created by bws2007 on 06.08.17.
//  Copyright © 2017 bws2007. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

class PostsTableViewController: UITableViewController {
    
    var Post = PostsAPI()
    
    override var prefersStatusBarHidden: Bool {
        return true //hide status bar
    }

    // MARK: - IBActions
    
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        Post.ViewController = self
        Post.getPostsWith { [weak self] (downloadedPosts)  in

            if let unwrapedPosts = downloadedPosts
            {
                if self?.posts == nil
                {
                    self?.posts = unwrapedPosts
                }
                
                self?.posts?.append(contentsOf: unwrapedPosts)
                
                self?.tableView.reloadData()
                
                self?.coreDataManager.save(posts: unwrapedPosts)
            }

            sender.endRefreshing()
        }
        if (isInternetAvailable() == false) {
            let message = "No internet connection available"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {action in
                sender.endRefreshing()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts = self.coreDataManager.fetchPosts()
    }

    // MARK: - connection to network
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    // MARK: - Table view data source

    var coreDataManager = CoreDataManager()
    var posts: [Post]?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewControllerTableViewCellIdentifier", for: indexPath)

        if let title = posts![indexPath.row].title
        {
            cell.textLabel?.text = "\(posts![indexPath.row].userID) - " + title
        }
        else
        {
            cell.textLabel?.text = "\(posts![indexPath.row].userID)"
        }
        
        cell.detailTextLabel?.text = posts![indexPath.row].body

        return cell
    }
}

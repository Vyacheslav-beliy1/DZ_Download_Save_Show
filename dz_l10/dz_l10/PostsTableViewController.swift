//
//  PostsTableViewController.swift
//  dz_l10
//
//  Created by bws2007 on 06.08.17.
//  Copyright © 2017 bws2007. All rights reserved.
//

import UIKit
import CoreData

class PostsTableViewController: UITableViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true //hide status bar
    }

    // MARK: - IBActions
    
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        PostsAPI.getPostsWith { [weak self] (downloadedPosts)  in

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
    }
    
    // MARK: - VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts = self.coreDataManager.fetchPosts()
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

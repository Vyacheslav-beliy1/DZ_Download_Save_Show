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
        return true
    }

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
            }

            sender.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    var posts: [Post]?

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewControllerTableViewCellIdentifier", for: indexPath)

        if let title = posts![indexPath.row].title
        {
            cell.textLabel?.text = "\(posts![indexPath.row].userID)" + title
        }
        else
        {
            cell.textLabel?.text = "\(posts![indexPath.row].userID)"
        }
        
        cell.detailTextLabel?.text = posts![indexPath.row].body

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

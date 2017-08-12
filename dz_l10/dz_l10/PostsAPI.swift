//
//  PostsAPI.swift
//  dz_l10
//
//  Created by bws2007 on 06.08.17.
//  Copyright © 2017 bws2007. All rights reserved.
//

import Foundation

class PostsAPI
{
    var ViewController: PostsTableViewController?
    
    private static var userID: Int = 1
    
    private static let baseURLstring = "http://jsonplaceholder.typicode.com/posts?userId="
    
    func getPostsWith(complition: @escaping ([Post]?) -> Void)
    {
        let stringURL = PostsAPI.baseURLstring + "\(PostsAPI.userID)"
        
        if let url = URL(string: stringURL)
        {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let taskError = error
                {
                    print(taskError.localizedDescription)
                    return
                }
                
                var posts:[Post] = []
                
                if let downloadetData = data
                {
                    if let json = (try? JSONSerialization.jsonObject(with: downloadetData, options: [])) as? [[String:Any]]
                    {
                        for postJSON in json
                        {
                            if let downloadedPost = Post.postFrom(json: postJSON) {
                              posts.append(downloadedPost)
                            }
                        }
                    }
                }

                DispatchQueue.main.async {
                    complition(posts.count > 0 ? posts : nil)
                }
            }.resume()
        }
        if (ViewController?.isInternetAvailable() == false) {
            
        } else {
            PostsAPI.userID += 1
        }
    }
}

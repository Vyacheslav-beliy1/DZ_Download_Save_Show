//
//  CoreDataManager.swift
//  dz_l10
//
//  Created by bws2007 on 06.08.17.
//  Copyright © 2017 bws2007. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager
{
    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    func printDatabaseStatistics() {
        if let context = container?.viewContext
        {
            let postRequest:NSFetchRequest<CDPost> = CDPost.fetchRequest()
            if let postCount = (try? context.fetch( postRequest ))?.count
            {
                print("\(postCount)")
            }
        }
    }
    
    func save(posts:[Post])
    {
        if let context = container?.viewContext {
            context.perform {
                [weak self] in
                
                for post in posts
                {
                    _ = try? CDPost.findOrCreate(with: post, in: context)
                }
                
                try? context.save()
                
                self?.printDatabaseStatistics()
            }
        }
    }
    
    func fetchPosts() -> [Post]? {
        
        //we can improve this line of code
        var posts: [Post] = []
        
        if let context = container?.viewContext
        {
            let postRequest: NSFetchRequest<CDPost> = CDPost.fetchRequest()
            
            if let cdPosts = try? context.fetch(postRequest)
            {
                for cdPost in cdPosts
                {
                    let post = Post.postFrom(cdPost: cdPost)
                    posts.append(post)
                }
            }
        }
        
        return posts.count > 0 ? posts : nil;
    }

    
}

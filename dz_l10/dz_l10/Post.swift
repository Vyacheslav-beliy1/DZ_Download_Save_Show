//
//  Post.swift
//  dz_l10
//
//  Created by bws2007 on 06.08.17.
//  Copyright © 2017 bws2007. All rights reserved.
//

import Foundation

class Post
{
    var userID: Int64
    var identifier: Int64
    var title: String?
    var body: String?
    
    init(userID: Int64,identifier: Int64,title: String?,body: String?) {
        self.userID = userID
        self.identifier = identifier
        self.title = title
        self.body = body
    }
}

// MARK: JSON extension
extension Post
{
    class func initFrom(json:[String:Any]) -> Post?
    {
        guard let userID = json["userId"] as? Int64,
            let id = json["id"] as? Int64
            else { return nil}
        
        return Post(userID: userID,
                    identifier: id,
                    title: json["title"] as? String,
                    body: json["body"] as? String)
    }
}

// MARK: CoreData extension
extension Post
{
    init(cdPost:CDPost)
    {
       return Post(userID: cdPost.userID,
                   identifier: cdPost.identifier,
                   title: cdPost.title,
                   body: cdPost.body)
    }
}

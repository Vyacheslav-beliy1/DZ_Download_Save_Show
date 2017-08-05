//
//  CDPost.swift
//  dz_l10
//
//  Created by bws2007 on 06.08.17.
//  Copyright © 2017 bws2007. All rights reserved.
//

import UIKit
import CoreData

class CDPost: NSManagedObject {
    
    class func findOrCreate(with thePost:Post,in context:NSManagedObjectContext ) throws -> CDPost {
        
        let request: NSFetchRequest<CDPost> = CDPost.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", thePost.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0
            {
                assert(matches.count > 1, "Someohw therare not ONE object with identifier")
                return matches[0]
            }
        } catch {
            //fail error and crash
            throw error
        }
        
        let cdPost = CDPost(context: context)
        cdPost.identifier = thePost.identifier
        cdPost.userID = thePost.userID
        cdPost.title = thePost.title
        cdPost.body = thePost.body
        
        return cdPost
    }
}

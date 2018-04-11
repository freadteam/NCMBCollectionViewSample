//
//  Post.swift
//  CollectionViewSalple
//
//  Created by Ryo Endo on 2018/04/11.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class Post: NSObject {

    var objectId: String
    var imageUrl: String!
    var user: User
    
    init(objectId: String, imageUrl: String, user: User) {
        self.imageUrl = imageUrl
        self.objectId = objectId
        self.user = user
    }
}

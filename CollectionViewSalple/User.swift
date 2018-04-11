//
//  User.swift
//  CollectionViewSalple
//
//  Created by Ryo Endo on 2018/04/11.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class User: NSObject {
    var objectId: String
    var name: String
    
    init(objectId: String, name: String) {
        self.name = name
        self.objectId = objectId
      
    }
}

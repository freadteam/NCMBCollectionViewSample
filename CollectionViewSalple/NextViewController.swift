//
//  NextViewController.swift
//  CollectionViewSalple
//
//  Created by Ryo Endo on 2018/04/10.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import NCMB
//画像サイズをリサイズする
import NYXImagesKit
import Kingfisher

class NextViewController: UIViewController {
    
    var selectedImageUrl: String?
    @IBOutlet var selectedImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

  
        selectedImageView.kf.setImage(with: URL(string: selectedImageUrl!))
        print(selectedImageUrl)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadSelectedImage() {
        
    }

}

//
//  PostViewController.swift
//  CollectionViewSalple
//
//  Created by Ryo Endo on 2018/04/11.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//


import UIKit
import NCMB
//画像サイズをリサイズする
import NYXImagesKit
import Kingfisher

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var resizedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //アルバムから画像を選んだ時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //サイズを圧縮する
        resizedImage = selectedImage.scale(byFactor: 0.4)
        
        // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = UIImagePNGRepresentation(resizedImage)
        // ここを変更（ファイル名無いので）
        let file = NCMBFile.file(with: data) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil {
                print(error)
                let alert = UIAlertController(title: "画像アップロードエラー", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                // 画像アップロードが成功
                let postObject = NCMBObject(className: "Post")
                postObject?.setObject(NCMBUser.current(), forKey: "user")
                let url = "https://mb.api.cloud.nifty.com/2013-09-01/applications/0RVcNvuvlaNUiKiI/publicFiles/" + file.name
                postObject?.setObject(url, forKey: "imageUrl")
                postObject?.saveInBackground({ (error) in
                    if error != nil {
                        print(error)
                    } else {
                    }
                })
            }
        }) { (progress) in
            print(progress)
        }
    }
    
    
    
    //カメラを起動
    @IBAction func camera() {
        //カメラが起動できる時
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            
            let picker = UIImagePickerController()
            //カメラをソースとする
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            print("カメラは使用できません")
        }
    }
    // アルバムを使うにはinfo.plistでプライバシー設定をしなきゃいけない
    //ライブラリの起動
    @IBAction func album() {
        let picker = UIImagePickerController()
        //ライブラリをソースとする
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

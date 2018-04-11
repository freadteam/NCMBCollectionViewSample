//
//  ViewController.swift
//  CollectionViewSalple
//
//  Created by Ryo Endo on 2018/04/10.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB
//画像サイズをリサイズする
import NYXImagesKit
import Kingfisher

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var sampleCollectionView: UICollectionView!
    var posts = [Post]()
    var selectedPost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sampleCollectionView.dataSource = self
        sampleCollectionView.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         loadimages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //セルに表示させる処理
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //cellの登録
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        //imageViewとセルの結びつけ
        let sampleView = cell.viewWithTag(1) as! UIImageView
        let imageUrl = posts[indexPath.row].imageUrl
        sampleView.kf.setImage(with: URL(string: imageUrl!))
        
        return cell
    }
    
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    //storyboradでimageviewmの制約とcell間の余白の調整が必要
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize:CGFloat = self.view.bounds.width/3 - 2
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    //選択されたセルの処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        selectedPost = posts[indexPath.row]
         performSegue(withIdentifier: "toNext", sender: nil)
    }
    
    //受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNext" {
        let nextViewController = segue.destination as! NextViewController
       nextViewController.selectedImageUrl = selectedPost?.imageUrl
        
        }
        
        
    }
   
    func loadimages() {
        let query = NCMBQuery(className: "Post")
        
        // 降順
        query?.order(byDescending: "createDate")
        
        //今のuserの投稿のみを持ってくる
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()
                
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                        // 投稿したユーザーの情報をUserモデルにまとめる
                    let userModel = User(objectId: user.objectId, name: user.userName)
                    
                        // 投稿の情報を取得
                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
                        
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                    let post = Post(objectId: postObject.objectId, imageUrl: imageUrl, user: userModel)

                        // 配列に加える
                        self.posts.append(post)
                    }
                
                // 投稿のデータが揃ったらリロード
                self.sampleCollectionView.reloadData()
            }
        })
        
    }
    
    
    
}


//
//  CommentViewController.swift
//  Instagram
//
//  Created by Nana Takase on 2018/11/11.
//  Copyright © 2018 yokune1014. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class CommentViewController: UIViewController, UITextFieldDelegate {
  
  var postData : PostData?
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  
  //送信ボタン押下時
  @IBAction func button(_ sender: Any) {
    let commentText = textField.text
    let uid = Auth.auth().currentUser?.displayName
    
    if commentText == ""{
      SVProgressHUD.showError(withStatus: "コメントを入力してください")
      return
      
    }else{
      
      postData?.comment.append("\(uid!) : \(commentText!)" )
      let comments = ["comment":postData?.comment]
      
      let postRef = Database.database().reference().child(Const.PostPath).child((postData?.id)!)
      postRef.updateChildValues(comments)
      
      //モーダルを閉じる
      self.dismiss(animated: true, completion: nil)
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = postData?.image
    
    textField.delegate = self
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを閉じる
    textField.resignFirstResponder()
    return true
  }
  
}

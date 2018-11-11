//
//  SettingViewController.swift
//  Instagram
//
//  Created by Nana Takase on 2018/11/10.
//  Copyright © 2018 yokune1014. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD


class SettingViewController: UIViewController {
  
  @IBOutlet weak var displayNameTextField: UITextField!
  
  //表示名変更ボタン押下
  @IBAction func handleChangeButton(_ sender: Any) {
    if let displayName = displayNameTextField.text{
      //表示名が入力されていない時はHUDwo出して何もしない
      if displayName.isEmpty{
        SVProgressHUD.showError(withStatus: "表示名を入力してください")
      }
      //表示名を設定する
      let user = Auth.auth().currentUser
      if let user = user {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        changeRequest.commitChanges{ error in
          if let error = error  {
            SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
            print("DEBUG_PRINT: " + error.localizedDescription)
            return
          }
          print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
          
          // HUDで完了を知らせる
          SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
        }
      }
    }
    self.view.endEditing(true)
  }
  
  //ログアウトボタン押下
  @IBAction func handleLogoutButton(_ sender: Any) {
    //ログアウトする
    try! Auth.auth().signOut()
    
    //ログイン画面を表示する
    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
    self.present(loginViewController!, animated: true, completion: nil)
    
    //ログイン画面から戻ってきた時のためにホーム画面を選択している状態にしておく
    let tabBarController = parent as! ESTabBarController
    tabBarController.setSelectedIndex(0, animated: false)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //ログイン中の表示名を取得して設定
    let user = Auth.auth().currentUser
    if let user = user {
      displayNameTextField.text = user.displayName
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

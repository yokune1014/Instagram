//
//  LoginViewController.swift
//  Instagram
//
//  Created by Nana Takase on 2018/11/10.
//  Copyright © 2018 yokune1014. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import  SVProgressHUD

class LoginViewController: UIViewController {
  
  @IBOutlet weak var mailAddressTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var displayNameTextField: UITextField!
  
  //ログインボタン押下
  @IBAction func handleLoginButton(_ sender: Any) {
    if let address = mailAddressTextField.text,
      let password = passwordTextField.text{
      
      //アドレス、パスワードのいずれかが入力されていない場合はなにもしない
      if  address.isEmpty || password.isEmpty {
        SVProgressHUD.showError(withStatus: "必須項目を入力してください")
        return
      }
      
      //HUDで処理中を表示
      SVProgressHUD.show()
      
      Auth.auth().signIn(withEmail: address, password: password){ user, error in
        if let error = error {
          print("DEBUG_PRINT: " + error.localizedDescription)
          return
        }else{
          print("DEBUG_PRINT: ログインに成功しました" )
          //HUDを消す
          SVProgressHUD.dismiss()
        }
        //画面を閉じてViewControllerに戻る
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  //アカウント作成押下
  @IBAction func handleCreateAccountButton(_ sender: Any) {
    if let address = mailAddressTextField.text,
      let password = passwordTextField.text,
      let displayName = displayNameTextField.text{
      
      //アドレス、パスワード、表示名のいずれかが入力されていない場合何もしない
      if address.isEmpty || password.isEmpty || displayName.isEmpty{
        print("DEBUG_PRINT: 何かが空文字です")
        SVProgressHUD.showError(withStatus: "必須項目を入力してください")
        return
      }
      
      // HUDで処理中を表示
      SVProgressHUD.show()
      
      //アドレスとパスワードでユーザー作成。
      Auth.auth().createUser(withEmail: address, password: password) { user, error in
        if let error = error {
          print("DEBUG_PRINT: " + error.localizedDescription)
          SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
          return
        }
        print("DEBUG_PRINT: ユーザー作成に成功しました。")
        
        //表示名を設定する
        let user = Auth.auth().currentUser
        if let user = user {
          let changeRequest = user.createProfileChangeRequest()
          changeRequest.displayName = displayName
          changeRequest.commitChanges{ error in
            if let error = error {
              //プロフィール更新でエラーが発生
              print("DEBUG_PRINT: " + error.localizedDescription)
              return
            }
            print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
            
            //HUDを消す
            SVProgressHUD.dismiss()
            
            //画面を閉じてViewControllerに戻る
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
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
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

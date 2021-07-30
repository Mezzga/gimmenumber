//
//  LoginController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 29/08/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class LoginController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var lblSignIn : UILabel!
    @IBOutlet weak var lblSignInDetail : UILabel!
    @IBOutlet weak var  viewUserName: CustomView!
    @IBOutlet weak var  viewPassword: CustomView!
    @IBOutlet weak var  txtUserName: CustomTextField!
    @IBOutlet weak var  txtPassword : CustomTextField!
    @IBOutlet weak var  btnSignUp : UIButton!
    @IBOutlet weak var  lblUsernameError : UILabel!
    @IBOutlet weak var  lblPasswordError : UILabel!
    @IBOutlet weak var  lblOrMessage : UILabel!
    @IBOutlet weak var  btnSignIn : CustomButton!
    @IBOutlet weak var  btnForgetPassword : UIButton!
    @IBOutlet weak var  btnBack : UIButton!
    @IBOutlet weak var  btnSignUp1 : UIButton!

    
    
    weak var activeField: CustomTextField?
    override func viewDidLoad() {
        super.viewDidLoad()
     
       txtUserName.delegate = self
        txtPassword.delegate = self
        btnSignUp.addTarget(self, action: #selector(self.btnSignUp(_sender:)), for: .touchUpInside)
        btnSignUp1.addTarget(self, action: #selector(self.btnSignUp1(_sender:)), for: .touchUpInside)
       
       

        // Do any additional setup after loading the view.
    }
@objc func btnSignUp1(_sender: UIButton){
    self.view.endEditing(true)
    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "SignupController") as! SignupController
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnForgot(_ sender: Any) {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotController") as! ForgotController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func btnSignUp(_sender: UIButton){
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessSignupController") as! BusinessSignupController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickBack(_ sender: UIButton) {
       
           exit(0)
    }
    func validateForm() -> Bool
    {
        var errorMessage  : Bool! = true
        let isValidEmail = Validations.isValidEmailAddress(emailAddressString: txtUserName.text!)
        if txtUserName.text!.trim().isEmpty
        {
            errorMessage = false
            lblUsernameError.text = "Please enter email address"
            viewUserName.setErrorColor()
        }
        else if txtUserName.text!.trim().isNotEmpty && !isValidEmail
        {
            errorMessage = false
            lblUsernameError.text = "Please enter valid email address"
            viewUserName.setErrorColor()
        }
        else{
            lblUsernameError.text = ""
            viewUserName.setBlackBorder()
        }
        
        if txtPassword.text!.trim().isEmpty
        {
            errorMessage = false
            viewPassword.setErrorColor()
            lblPasswordError.text = "Please enter a password"
        }
        else if txtPassword.text!.trim().count < 8
        {
            errorMessage = false
            viewPassword.setErrorColor()
            lblPasswordError.text = "Please enter a valid password"
        }
        else{
            lblPasswordError.text = ""
            viewPassword.setBlackBorder()
        }
        return errorMessage
    }
    
    
    @IBAction func btnSignIn(_ sender: CustomButton) {
        txtUserName.resignFirstResponder()
        txtPassword.resignFirstResponder()
        if validateForm()
        {
            
            var Parameters = [String: String]()
            Parameters["email"] = txtUserName.text!
            Parameters["password"] = txtPassword.text!
            Parameters["device"] = "I"
            print(Parameters)
            btnSignIn.showLoading()
            Alamofire.request(
                URL_Login ,
                method: .post,
                parameters: Parameters,
                encoding: JSONEncoding(options: [])
                )
                .validate()
                .responseJSON { (response) -> Void in
                    self.btnSignIn.hideLoading()
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary)
                        
                        let success = ary.value(forKey: "status") as! NSDictionary
                        let code = success.value(forKey: "code") as! NSNumber

                        if(code == 1000){
                            
                     let result = ary.value(forKey: "result") as! NSDictionary
                    UserDefaults.standard.set(result.value(forKey: "uid") as! NSString, forKey: "userid")
                    UserDefaults.standard.set(result.value(forKey: "token_authentication") as! NSString, forKey: "apikey")
                    UserDefaults.standard.set(result.value(forKey: "email") as! NSString, forKey: "email")
                            
                            if let alt_email = result["alt_email"] as? String {
                                UserDefaults.standard.set(alt_email, forKey: "alt_email")
                            }
                            else if (result["alt_email"] as? NSNull) != nil {
                               UserDefaults.standard.set("", forKey: "alt_email")
                            }
                           

                      UserDefaults.standard.set(result.value(forKey: "roleid") as! NSString, forKey: "roleid")
                    UserDefaults.standard.synchronize()
                            
                            if(result.value(forKey: "status") as! NSString == "0"){
                                self.view.endEditing(true)
                                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "VerifyotpController") as! VerifyotpController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                self.view.endEditing(true)
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.login()
                            }
                            
                            
                        }else{
                            
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                        }
                    }
                        
                        
                    else {
                        print(response.response as Any)
                        if(response.response?.statusCode == 401){
                            if let data = response.data {
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                    print(json as Any)
                                    if json is [String: String]{
                                        self.view.makeToast(((json as! NSDictionary)["message"] as! String), duration: 3.0, position: .bottom)

                                    }else{
                                        let ary =  (json as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                        if(ary.value(forKey: "message")as! String == "invalid_token"){
                                            self.view.endEditing(true)
                                            UserDefaults.standard.removeObject(forKey: "userid")
                                            UserDefaults.standard.removeObject(forKey: "apikey")
                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            appDelegate.login()
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }else{
                            
                            print("Error while fetching remote rooms: \(String(describing: response.result.value))")
                            let dialogMessage = UIAlertController(title: "", message: NSLocalizedString("Something went wrong", comment: ""), preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: NSLocalizedString("Reload", comment: ""), style: .default, handler: { (action) -> Void in
                                print("Ok button click...")
                            })
                            
                            dialogMessage.addAction(ok)
                            //  dialogMessage.addAction(cancel)
                            
                            // Present dialog message to user
                            self.present(dialogMessage, animated: true, completion: nil)
                        }
                    }
            }
            
            
        }
    }
    
    //MARK:- text delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldResignFocus((textField as? CustomTextField)!)
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField as? CustomTextField
        self.textFieldFocus(activeField!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtUserName.isFirstResponder
        {
            txtPassword.becomeFirstResponder()
        }
        else if txtPassword.isFirstResponder
        {
            txtPassword.resignFirstResponder()
        }
        return false
    }
    
    func textFieldFocus(_ textField: CustomTextField)
    {
        if textField == txtUserName && txtUserName.text!.trim().isEmpty && !viewUserName.isErrorColor()
        {
            viewUserName.setBlackBorder()
        }
        else if textField == txtPassword && txtPassword.text!.trim().isEmpty && !viewPassword.isErrorColor()
        {
            txtPassword.placeholder = "Password (Min. 8 characters)"
            viewPassword.setBlackBorder()
        }
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        if textField == txtUserName && txtUserName.text!.trim().isEmpty && !viewUserName.isErrorColor()
        {
            viewUserName.setlighGrayColor()
        }
        else if textField == txtPassword && txtPassword.text!.trim().isEmpty && !viewPassword.isErrorColor(){
            viewPassword.setlighGrayColor()
            txtPassword.placeholderLabel.text = "Password"
        }
    }
    
    
    
    // MARK: - keyboard show
    @objc func keyboardDidShow(_ notification: Notification)
    {
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+30, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification)
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.contentOffset = .zero
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

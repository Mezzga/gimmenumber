//
//  VerifyotpController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 05/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire

class VerifyotpController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var  viewOtp: CustomView!
    @IBOutlet weak var  btnVerifyotp : CustomButton!
    @IBOutlet weak var  txtOtp: CustomTextField!
    @IBOutlet weak var lblOtpError : UILabel!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var vw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOtp.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)


        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnVerifyotp(_ sender: CustomButton) {
        self.view.endEditing(true)
        if validateForm()
        {
            
            var Parameters = [String: String]()
            Parameters["email"] = (UserDefaults.standard.value(forKey: "email") as! String)
            Parameters["otp"] = txtOtp.text!

            print(Parameters)
            btnVerifyotp.showLoading()
            Alamofire.request(
                URL_Checkotp ,
                method: .post,
                parameters: Parameters,
                encoding: JSONEncoding(options: [])
                )
                .validate()
                .responseJSON { (response) -> Void in
                    self.btnVerifyotp.hideLoading()
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary.value(forKey: "status") as Any)
                        
                        let success = ary.value(forKey: "status") as! NSDictionary
                        let code = success.value(forKey: "code") as! NSNumber
                        if(code == 1000){
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.login()
                            
                            
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
    
    func validateForm() -> Bool
    {
        var errorMessage  : Bool! = true
    //    let isValidEmail = Validations.isValidEmailAddress(emailAddressString: txtOtp.text!)
        if txtOtp.text!.trim().isEmpty
        {
            errorMessage = false
            lblOtpError.text = "Please enter OTP"
            viewOtp.setErrorColor()
        }
//        else if txtOtp.text!.trim().isNotEmpty && !isValidEmail
//        {
//            errorMessage = false
//            lblOtpError.text = "Please enter valid email address"
//            viewOtp.setErrorColor()
//        }
        else{
            lblOtpError.text = ""
            viewOtp.setBlackBorder()
        }
        return errorMessage
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldResignFocus((textField as? CustomTextField)!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldFocus((textField as? CustomTextField)!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtOtp.isFirstResponder
        {
            txtOtp.resignFirstResponder()
        }
        return false
    }
    
    func textFieldFocus(_ textField: CustomTextField)
    {
        if textField == txtOtp && txtOtp.text!.trim().isEmpty && !viewOtp.isErrorColor()
        {
            viewOtp.setBlackBorder()
        }
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        if textField == txtOtp && txtOtp.text!.trim().isEmpty && !viewOtp.isErrorColor()
        {
            viewOtp.setlighGrayColor()
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

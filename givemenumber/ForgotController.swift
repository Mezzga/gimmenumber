//
//  ForgotController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 04/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire

class ForgotController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var viewEmail: CustomView!
    @IBOutlet weak var btnForgot : CustomButton!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblEmailError : UILabel!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var vw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnForgot(_ sender: CustomButton) {
         self.view.endEditing(true)
        if validateForm()
        {
            
            var Parameters = [String: String]()
            Parameters["email"] = txtEmail.text!
            print(Parameters)
            btnForgot.showLoading()
            Alamofire.request(
                URL_Forgotpass ,
                method: .post,
                parameters: Parameters
                )
                .validate()
                .responseJSON { (response) -> Void in
                    self.btnForgot.hideLoading()
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary.value(forKey: "status") as Any)
                        
                        let success = ary.value(forKey: "status") as! NSDictionary
                        let code = success.value(forKey: "code") as! NSNumber
                        if(code == 1000){
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)

                            
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
            let isValidEmail = Validations.isValidEmailAddress(emailAddressString: txtEmail.text!)
            if txtEmail.text!.trim().isEmpty
            {
                errorMessage = false
                lblEmailError.text = "Please enter email address"
                viewEmail.setErrorColor()
            }
            else if txtEmail.text!.trim().isNotEmpty && !isValidEmail
            {
                errorMessage = false
                lblEmailError.text = "Please enter valid email address"
                viewEmail.setErrorColor()
            }
            else{
                lblEmailError.text = ""
                viewEmail.setBlackBorder()
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
        if txtEmail.isFirstResponder
        {
            txtEmail.resignFirstResponder()
        }
        return false
    }
    
    func textFieldFocus(_ textField: CustomTextField)
    {
        if textField == txtEmail && txtEmail.text!.trim().isEmpty && !viewEmail.isErrorColor()
        {
            viewEmail.setBlackBorder()
        }
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        if textField == txtEmail && txtEmail.text!.trim().isEmpty && !viewEmail.isErrorColor()
        {
            viewEmail.setlighGrayColor()
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

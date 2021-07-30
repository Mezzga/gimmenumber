//
//  ChangepasswordController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 05/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
class ChangepasswordController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnChangepass: CustomButton!
    @IBOutlet weak var txtOldpass: CustomTextField!
    @IBOutlet weak var lblOldpassError : UILabel!
    @IBOutlet weak var viewOldpass: CustomView!
    @IBOutlet weak var txtNewpass: CustomTextField!
    @IBOutlet weak var lblNewpassError : UILabel!
    @IBOutlet weak var  viewNewpass: CustomView!
    @IBOutlet weak var txtConfirmpass: CustomTextField!
    @IBOutlet weak var lblConfirmpassError : UILabel!
    @IBOutlet weak var  viewConfirmpass: CustomView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtOldpass.delegate = self
        txtNewpass.delegate = self
        txtConfirmpass.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//        let  navController = self.tabBarController?.viewControllers![3] as! UINavigationController
//        let secondViewController = navController.viewControllers[0] as! UserlistController
//        tabBarController!.selectedIndex = 3
        
    }
    @IBAction func btnChangepass(_ sender: CustomButton) {
        self.view.endEditing(true)
        if validateForm(){
            
            var Parameters = [String: String]()
            Parameters["oldpass"] = txtOldpass.text!
            Parameters["newpass"] = txtNewpass.text!
            print(Parameters)
            btnChangepass.showLoading()
            Alamofire.request(
                URL_Changepassword ,
                method: .post,
                parameters: Parameters,
                headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String),
                 "Content-Type":"application/x-www-form-urlencoded"]
                )
                .validate()
                .responseJSON { (response) -> Void in
                    self.btnChangepass.hideLoading()
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary)
                        
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

        if txtOldpass.text!.trim().isEmpty
        {
            errorMessage = false
            viewOldpass.setErrorColor()
            lblOldpassError.text = "Please enter Correct Old Password"
        }
        else if txtOldpass.text!.trim().count < 8
        {
            errorMessage = false
            viewOldpass.setErrorColor()
            lblOldpassError.text = "Please enter Correct Old Password"
        }
        else{
            lblOldpassError.text = ""
            viewOldpass.setBlackBorder()
        }
        
        if txtNewpass.text!.trim().isEmpty
        {
            errorMessage = false
            viewNewpass.setErrorColor()
            lblNewpassError.text = "Please enter a Valid Password"
        }
        else if txtNewpass.text!.trim().count < 8
        {
            errorMessage = false
            viewNewpass.setErrorColor()
            lblNewpassError.text = "Please enter a Valid Password"
        }
        else{
            lblNewpassError.text = ""
            viewNewpass.setBlackBorder()
        }
        
        if txtConfirmpass.text!.trim().isEmpty
        {
            errorMessage = false
            viewConfirmpass.setErrorColor()
            lblConfirmpassError.text = "Please enter a Valid Password"
        }
        else if txtConfirmpass.text!.trim().count < 8
        {
            errorMessage = false
            viewConfirmpass.setErrorColor()
            lblConfirmpassError.text = "Please enter a Valid Password"
        }
        else{
            lblConfirmpassError.text = ""
            viewConfirmpass.setBlackBorder()
        }
        
        if(txtNewpass.text! != txtConfirmpass.text!){
            errorMessage = false
            viewConfirmpass.setErrorColor()
            lblConfirmpassError.text = "Please enter a Valid Password"
        }else{
            lblConfirmpassError.text = ""
            viewConfirmpass.setBlackBorder()
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
        if txtOldpass.isFirstResponder
        {
            txtNewpass.becomeFirstResponder()
        }else if txtNewpass.isFirstResponder
        {
            txtConfirmpass.becomeFirstResponder()
        }else if txtConfirmpass.isFirstResponder{
            txtConfirmpass.resignFirstResponder()
        }
        return false
    }
    
    func textFieldFocus(_ textField: CustomTextField)
    {
        if textField == txtOldpass && txtOldpass.text!.trim().isEmpty && !viewOldpass.isErrorColor()
        {
            txtOldpass.placeholder = "Password (Min. 8 characters)"
            viewOldpass.setBlackBorder()
        }
        else if textField == txtNewpass && txtNewpass.text!.trim().isEmpty && !viewNewpass.isErrorColor()
        {
            txtNewpass.placeholder = "Password (Min. 8 characters)"
            viewNewpass.setBlackBorder()
        } else if textField == txtConfirmpass && txtConfirmpass.text!.trim().isEmpty && !viewConfirmpass.isErrorColor()
        {
            txtConfirmpass.placeholder = "Password (Min. 8 characters)"
            viewConfirmpass.setBlackBorder()
        }
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        if textField == txtOldpass && txtOldpass.text!.trim().isEmpty && !viewOldpass.isErrorColor(){
            viewOldpass.setlighGrayColor()
            txtOldpass.placeholderLabel.text = "Password"
        }else if textField == txtNewpass && txtNewpass.text!.trim().isEmpty && !viewNewpass.isErrorColor(){
            viewNewpass.setlighGrayColor()
            txtNewpass.placeholderLabel.text = "Password"
        }else if textField == txtConfirmpass && txtConfirmpass.text!.trim().isEmpty && !viewConfirmpass.isErrorColor(){
            viewConfirmpass.setlighGrayColor()
            txtConfirmpass.placeholderLabel.text = "Password"
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

//
//  SignupController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 03/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import FlagPhoneNumber

class SignupController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FPNTextFieldDelegate {

    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var lblSignUp : UILabel!
    @IBOutlet weak var lblSignUpDetail : UILabel!
    
    
    @IBOutlet weak var  cvw: UIView!

    @IBOutlet weak var  viewFirstName: CustomView!
    @IBOutlet weak var  viewLastName: CustomView!
    @IBOutlet weak var  viewEmail: CustomView!
    @IBOutlet weak var  viewMobile: CustomView!
    @IBOutlet weak var  viewPassword: CustomView!
    
    
    @IBOutlet weak var  txtFirstName: CustomTextField!
    @IBOutlet weak var  txtLastName: CustomTextField!
    @IBOutlet weak var  txtMobile: FPNTextField!
    @IBOutlet weak var  txtEmail: CustomTextField!
    @IBOutlet weak var  txtPassword : CustomTextField!
    
    @IBOutlet weak var  lblFirstNameError : UILabel!
    @IBOutlet weak var  lblLastNameError : UILabel!
    @IBOutlet weak var  lblEmailError : UILabel!
    @IBOutlet weak var  lblMobileError : UILabel!
    @IBOutlet weak var  lblPasswordError : UILabel!
    
    @IBOutlet weak var  btnSignUp : CustomButton!
    @IBOutlet weak var  btnSignIn : UIButton!
    @IBOutlet weak var  btnBack : UIButton!
    @IBOutlet weak var btnProfileimage: UIButton!
    @IBOutlet weak var btnBusinesssignup: UIButton!

    @IBOutlet weak var  txtTermsConditions : UITextView!
    
    weak var activeField: CustomTextField?
    
    
    var userid = ""
    var apikey = ""
    var roleid = ""
    var result : NSDictionary!
    
    var mobilevalid = false
    var dialcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnProfileimage.layer.cornerRadius = btnProfileimage.frame.size.height/2
        
        btnProfileimage.setImage(UIImage(named:"userIcon.png"), for: .normal)


        cvw.frame = CGRect(x: cvw.frame.origin.x, y: cvw.frame.origin.y
            , width: cvw.frame.size.width, height: vw.frame.size.height + vw.frame.origin.y + 10)
         scrollView.contentSize = CGSize(width:self.view.frame.size.width, height: cvw.frame.size.height+cvw.frame.origin.y)

        // Do any additional setup after loading the view.
    }
    func updateUI()
    {
        
        
        let tosString = "terms of services & payments."
        let message = "By Signingup you are agreeing to the\n \(tosString)"
        
        let localizedString = NSLocalizedString(message, comment: "")
        let tosRange: NSRange = (localizedString as NSString).range(of: NSLocalizedString(tosString, comment: ""), options: .caseInsensitive)
        
        //  let tostripeRange: NSRange = (localizedString as NSString).range(of: NSLocalizedString(stripeString, comment: ""), options: .caseInsensitive)
        
        //  let tosURL = URL(string: "https://www.pawops.com/terms.html")
        let tosURL = URL(string: "http://geniefinserv.in/gimme/terms_and_conditions.html")
        //   let tostripeURL = URL(string: "https://stripe.com/us/legal")
        
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let finalMessage =  NSMutableAttributedString(string: localizedString, attributes: [NSAttributedString.Key.paragraphStyle:paragraph])
        finalMessage.beginEditing()
        finalMessage.addAttribute(NSAttributedString.Key.link, value: tosURL!, range: tosRange)
        //   finalMessage.addAttribute(NSAttributedString.Key.link, value: tostripeURL!, range: tostripeRange)
        finalMessage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: tosRange)
        //  finalMessage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: tostripeRange)
        
        
        finalMessage.endEditing()
        finalMessage.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Light", size: 16.0)!, range: NSMakeRange(0, message.count))
        txtTermsConditions.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.underlineColor:UIColor.black]
        
        txtTermsConditions.attributedText = finalMessage
        txtTermsConditions.textColor = UIColor.black
//        if user != nil{
//            if user.email != nil && user.email!.isNotEmpty{
//                viewEmail.setBlackBorder()
//                txtEmail.text = user.email
//                txtEmail.isUserInteractionEnabled = false
//            }
//            if user.firstName != nil && user.firstName!.isNotEmpty{
//                viewFirstName.setBlackBorder()
//                txtFirstName.text = user.firstName
//                //   txtFirstName.isUserInteractionEnabled = false
//            }
//            if user.lastName != nil && user.lastName!.isNotEmpty{
//                txtLastName.text = user.lastName
//                viewLastName.setBlackBorder()
//                // viewLastName.isUserInteractionEnabled = false
//            }
//            if user.inviteCode != nil &&  user.inviteCode!.isNotEmpty{
//                viewInviteCode.setBlackBorder()
//                txtInviteCode.text = user.inviteCode
//                txtInviteCode.isUserInteractionEnabled = false
//            }
//            if user.mobileNumber != nil && user.mobileNumber!.isNotEmpty{
//                viewMobile.setBlackBorder()
//                txtMobile.text = user.mobileNumber
//                txtMobile.isUserInteractionEnabled = false
//            }
//        }
    }
    func releaseKeyboard()
    {
        txtMobile.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtFirstName.resignFirstResponder()
    }

    @IBAction func btnSignin(_ sender: Any) {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBusinesssignup(_ sender: Any) {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessSignupController") as! BusinessSignupController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProfileimage(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Please Select One", comment: ""), message: "", preferredStyle: .alert)
        
        let camera: UIAlertAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .cancel) { action -> Void in
            
            if(!UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                let alert = UIAlertController(title: "Error",
                                              message: "Device has no camera",
                                              preferredStyle: UIAlertController.Style.alert)
                
                let cancelAction = UIAlertAction(title: "OK",
                                                 style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                let picker = UIImagePickerController()
                //  picker.allowsEditing = true
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: false, completion: nil)
            }
        }
        let album: UIAlertAction = UIAlertAction(title: NSLocalizedString("Album", comment: ""), style: .default) { action -> Void in
            let picker = UIImagePickerController()
            // picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(picker, animated: false, completion: nil)
        }
        
        actionSheetController.addAction(camera)
        actionSheetController.addAction(album)
        self.present(actionSheetController, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    
        let chosenImage = info[.originalImage] as! UIImage //2
        btnProfileimage.setImage(chosenImage, for: .normal)
        btnProfileimage.layer.masksToBounds = true
        btnProfileimage.layer.cornerRadius = btnProfileimage.frame.size.width/2
        dismiss(animated:false, completion: nil)
    }
    
    @IBAction func btnSignup(_ sender: CustomButton) {
        self.releaseKeyboard()
        
        if validateForm()
        {
           self.register()
        }
    }
    func register(){
        
        let swiftyString = dialcode.replacingOccurrences(of: "+", with: " ")
        var mobile = swiftyString.trim() + txtMobile.text!.trim()
        mobile = mobile.replacingOccurrences(of: " ", with: "")
        
        var Parameters = [String: String]()
        Parameters["email"] = txtEmail.text!
        Parameters["password"] = txtPassword.text!
        Parameters["fname"] = txtFirstName.text!
        Parameters["lname"] = txtLastName.text!
        Parameters["mobile"] = mobile
        print(Parameters)
        btnSignUp.showLoading()
        Alamofire.request(
            URL_Userregister ,
            method: .post,
            parameters: Parameters,
            encoding: JSONEncoding(options: [])
            )
            .validate()
            .responseJSON { (response) -> Void in
                self.btnSignUp.hideLoading()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                     print(success)
                    
                    if(code == 1000){
                        
                        self.result = ary.value(forKey: "result") as! NSDictionary
                        self.userid = self.result.value(forKey: "uid")as! String
                        self.apikey = self.result.value(forKey: "token_authentication")as! String
                        self.roleid = self.result.value(forKey: "roleid")as! String

                        if (self.btnProfileimage.currentImage != UIImage(named: "userIcon.png")) {
                            self.imageregister()
                            
                        }else{
                            
                            UserDefaults.standard.set(self.result.value(forKey: "uid") as! NSString, forKey: "userid")
                            UserDefaults.standard.set(self.result.value(forKey: "token_authentication") as! NSString, forKey: "apikey")
                            UserDefaults.standard.set(self.result.value(forKey: "email") as! NSString, forKey: "email")
                            
                            if let alt_email = self.result["alt_email"] as? String {
                                UserDefaults.standard.set(alt_email, forKey: "alt_email")
                            }
                            else if (self.result["alt_email"] as? NSNull) != nil {
                                UserDefaults.standard.set("", forKey: "alt_email")
                            }
                            
                            
                            UserDefaults.standard.set(self.result.value(forKey: "roleid") as! NSString, forKey: "roleid")
                            UserDefaults.standard.synchronize()
                            
                            if(self.result.value(forKey: "status") as! NSString == "0"){
                                self.view.endEditing(true)
                                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "VerifyotpController") as! VerifyotpController
                                self.navigationController?.pushViewController(vc, animated: true)
                     //       self.register()
                        }
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
    
    func imageregister(){

        var Parameters = [String: String]()
        Parameters["roleid"] = roleid
        btnSignUp.showLoading()
        let value = btnProfileimage.currentImage

        //  let imgData = UIImageJPEGRepresentation(value! , 0.2)! as Data
        let imgData = value?.jpegData(compressionQuality: 0.3)

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "profile_pic",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in Parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:URL_Uploadimage,
                         method:.post,
                         headers:["userid": userid,
                                  "apikey":apikey,
                             "Content-Type":"application/x-www-form-urlencoded"])
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    print(response.result.value as Any)
                    self.btnSignUp.hideLoading()
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary)
                        
                        let success = ary.value(forKey: "status") as! NSDictionary
                        let code = success.value(forKey: "code") as! NSNumber
                        if(code == 1000){
                            
                            UserDefaults.standard.set(self.result.value(forKey: "uid") as! NSString, forKey: "userid")
                            UserDefaults.standard.set(self.result.value(forKey: "token_authentication") as! NSString, forKey: "apikey")
                            UserDefaults.standard.set(self.result.value(forKey: "email") as! NSString, forKey: "email")
                            
                            if let alt_email = self.result["alt_email"] as? String {
                                UserDefaults.standard.set(alt_email, forKey: "alt_email")
                            }
                            else if (self.result["alt_email"] as? NSNull) != nil {
                                UserDefaults.standard.set("", forKey: "alt_email")
                            }
                            
                            
                            UserDefaults.standard.set(self.result.value(forKey: "roleid") as! NSString, forKey: "roleid")
                            UserDefaults.standard.synchronize()
                            
                            if(self.result.value(forKey: "status") as! NSString == "0"){
                                self.view.endEditing(true)
                                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "VerifyotpController") as! VerifyotpController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else{
                            
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                        }
                    } else {
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
                        return
                    }

                }

            case .failure(let encodingError):
                print(encodingError)
            }

        }



    }
    
   
    
    func validateForm() -> Bool
    {
        var errorMessage  : Bool! = true
        let isValidEmail = Validations.isValidEmailAddress(emailAddressString: txtEmail.text!)
//        let isValidMobil = Validations.isValidPhoneNumber(phoneNumberString: txtMobile.text!)
    //    let isValidPassword = Validations.isPasswordValid(txtPassword.text!)
        //FirstName
        if txtFirstName.text!.trim().isEmpty
        {
            errorMessage = false
            lblFirstNameError.text = "Please enter first name"
            viewFirstName.setErrorColor()
        }
        else if txtFirstName.text!.trim().isNotEmpty && txtFirstName.text!.trim().count <= 2
        {
            errorMessage = false
            lblFirstNameError.text = "Please enter valid first name"
            viewFirstName.setErrorColor()
        }
        else{
            lblFirstNameError.text = ""
            viewFirstName.setBlackBorder()
        }
        
        //Lastname
        if txtLastName.text!.trim().isEmpty
        {
            errorMessage = false
            lblLastNameError.text = "Please enter last name"
            viewLastName.setErrorColor()
        }
        else if txtLastName.text!.trim().isNotEmpty && txtLastName.text!.trim().count <= 2
        {
            errorMessage = false
            lblLastNameError.text = "Please enter valid last name"
            viewLastName.setErrorColor()
        }
        else{
            lblLastNameError.text = ""
            viewLastName.setBlackBorder()
        }
        
        //Email
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
        //Password
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
        else if txtPassword.text!.trim().isNotEmpty 
        {
       //     errorMessage = false
      //      viewPassword.setErrorColor()
        ///    lblPasswordError.text = "Please enter a valid password"
            
            lblPasswordError.text = ""
            viewPassword.setBlackBorder()
        }
        else{
            lblPasswordError.text = ""
            viewPassword.setlighGrayColor()
        }
        
        //Mobile
        if txtMobile.text!.trim().isEmpty
        {
            errorMessage = false
            lblMobileError.text = "Please enter valid mobile number"
            viewMobile.setErrorColor()
        }
        else if mobilevalid == false
        {
            errorMessage = false
            lblMobileError.text = "Please enter valid mobile number"
            viewMobile.setErrorColor()
        }
        else{
            lblMobileError.text = ""
            viewMobile.setBlackBorder()
        }
        return errorMessage
    }
    
    //MARK:- UITextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == txtMobile){
            
        }else{
        self.textFieldResignFocus((textField as? CustomTextField)!)
        self.activeField = nil
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == txtMobile){
            
        }else{
        self.activeField = textField as? CustomTextField
        self.textFieldFocus(activeField!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
            return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtFirstName.isFirstResponder
        {
            txtLastName.becomeFirstResponder()
        }
        else if txtLastName.isFirstResponder
        {
            txtEmail.becomeFirstResponder()
        }
        else if txtEmail.isFirstResponder
        {
            txtPassword.becomeFirstResponder()
        }
        else if txtPassword.isFirstResponder
        {
            txtMobile.becomeFirstResponder()
        }
        else if txtMobile.isFirstResponder
        {
             txtMobile.resignFirstResponder()
        }
       
        return false
    }
    func textFieldFocus(_ textField: CustomTextField)
    {
        if textField == txtFirstName && txtFirstName.text!.trim().isEmpty && !viewFirstName.isErrorColor()
        {
            viewFirstName.setBlackBorder()
        }
        else if textField == txtLastName && txtLastName.text!.trim().isEmpty && !viewLastName.isErrorColor()
        {
            viewLastName.setBlackBorder()
        }
        else if textField == txtEmail && txtEmail.text!.trim().isEmpty && !viewEmail.isErrorColor()
        {
            viewEmail.setBlackBorder()
        }
        else if textField == txtPassword && txtPassword.text!.trim().isEmpty && !viewPassword.isErrorColor()
        {
            txtPassword.placeholder = "Password (Min. 8 characters)"
            viewPassword.setBlackBorder()
        }
        else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
        {
            viewMobile.setBlackBorder()
        }
       
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        if textField == txtFirstName && txtFirstName.text!.trim().isEmpty && !viewFirstName.isErrorColor()
        {
            viewFirstName.setlighGrayColor()
        }
        else if textField == txtLastName && txtLastName.text!.trim().isEmpty && !viewLastName.isErrorColor()
        {
            viewLastName.setlighGrayColor()
        }
        else if textField == txtEmail && txtEmail.text!.trim().isEmpty && !viewEmail.isErrorColor()
        {
            viewEmail.setlighGrayColor()
        }
        else if textField == txtPassword && txtPassword.text!.trim().isEmpty && !viewPassword.isErrorColor()
        {
            viewPassword.setlighGrayColor()
            txtPassword.placeholderLabel.text = "Password"
        }
        else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
        {
            viewMobile.setlighGrayColor()
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

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(code)
        print(name, dialCode, code)
        dialcode = dialCode
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            mobilevalid = true
            lblMobileError.text = ""
            viewMobile.setBlackBorder()
            print("valid")
            
        } else {
            mobilevalid = false
            lblMobileError.text = "Please enter valid mobile number"
            viewMobile.setErrorColor()
            print("notvalid")
            
            // Do something...
        }
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

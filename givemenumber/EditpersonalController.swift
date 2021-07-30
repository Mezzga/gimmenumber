//
//  EditpersonalController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 06/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import FlagPhoneNumber

class EditpersonalController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,FPNTextFieldDelegate {
    
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: CustomButton!
    @IBOutlet weak var btnProfileimage: UIButton!
    
    @IBOutlet weak var  viewFirstName: CustomView!
    @IBOutlet weak var  viewLastName: CustomView!
    @IBOutlet weak var  viewEmail: CustomView!
    @IBOutlet weak var  viewMobile: CustomView!
    @IBOutlet weak var  viewfacebook: CustomView!
       @IBOutlet weak var  viewtwitter: CustomView!
    
    @IBOutlet weak var  txtFirstName: CustomTextField!
    @IBOutlet weak var  txtLastName: CustomTextField!
    @IBOutlet weak var  txtMobile: FPNTextField!
    @IBOutlet weak var  txtEmail: CustomTextField!
    @IBOutlet weak var  txtfaceName: CustomTextField!
       @IBOutlet weak var  txttwitterName: CustomTextField!
    
    @IBOutlet weak var  lblFirstNameError : UILabel!
    @IBOutlet weak var  lblLastNameError : UILabel!
    @IBOutlet weak var  lblEmailError : UILabel!
    @IBOutlet weak var  lblMobileError : UILabel!
    
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var viewCountry1: UIView!
    @IBOutlet weak var viewSubcountry: UIView!
    @IBOutlet weak var txtSearch: CustomTextField!
    @IBOutlet weak var tblCountry: UITableView!
    @IBOutlet weak var btnHidecountry: UIButton!
    @IBOutlet weak var  lblEmpty : UILabel!

    
    weak var activeField: CustomTextField?
    
    
    var diffstr = ""
    var personaldet : NSDictionary!
    var email = ""
    
    var CompleteArray = [AnyObject]()
    var FilterDataArray = [AnyObject]()
    var mobilevalid = false
    var dialcode = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtMobile.delegate = self
        self.txtMobile.set(phoneNumber: "911234567890")
        
     
        

        
        
        if(diffstr == "1"){
            self.txtFirstName.text = (self.personaldet.value(forKey:"name") as! String)
            self.txtLastName.text = (self.personaldet.value(forKey:"lname") as! String)
            self.txtfaceName.text = (self.personaldet.value(forKey:"facebook") as! String)
            self.txttwitterName.text = (self.personaldet.value(forKey:"twitter") as! String)
            self.txtMobile.set(phoneNumber: (self.personaldet.value(forKey:"mobile") as! String))
            email = (self.personaldet.value(forKey:"email") as! String)
            if let profilepic = self.personaldet["profile_pic"] as? String {
                let img = PIMAGE + profilepic
                
                self.btnProfileimage.sd_setImage(with: URL(string: img), for: .normal, placeholderImage: UIImage(named: "userIcon.png"))
            }
            else if (self.personaldet["profile_pic"] as? NSNull) != nil {
                
                self.btnProfileimage.setImage(UIImage(named: "userIcon.png"), for: .normal)
            }
            
            viewEmail.isHidden = true
            viewMobile.frame = CGRect(x: viewMobile.frame.origin.x, y: viewLastName.frame.size.height  + viewLastName.frame.origin.y + 10, width: viewMobile.frame.size.width, height: viewMobile.frame.size.height)
            viewfacebook.frame = CGRect(x: viewfacebook.frame.origin.x, y: viewMobile.frame.size.height  + viewMobile.frame.origin.y + 10, width: viewfacebook.frame.size.width, height: viewfacebook.frame.size.height)
            viewtwitter.frame = CGRect(x: viewtwitter.frame.origin.x, y: viewfacebook.frame.size.height  + viewfacebook.frame.origin.y + 10, width: viewtwitter.frame.size.width, height: viewtwitter.frame.size.height)
            
            btnSave.frame = CGRect(x: btnSave.frame.origin.x, y: viewtwitter.frame.size.height  + viewtwitter.frame.origin.y + 10, width: btnSave.frame.size.width, height: btnSave.frame.size.height)
            vw.frame = CGRect(x: vw.frame.origin.x, y:vw.frame.origin.y, width: vw.frame.size.width, height: btnSave.frame.size.height  + btnSave.frame.origin.y + 10)
            
        }else{
            
             viewEmail.isHidden = false
            btnProfileimage.setImage(UIImage(named:"userIcon.png"), for: .normal)

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnProfileimage.layer.cornerRadius = btnProfileimage.frame.size.height/2
       
        scrollview.contentSize = CGSize(width:self.view.frame.size.width, height: vw.frame.size.height+vw.frame.origin.y)
        
        btnProfileimage.layer.cornerRadius = btnProfileimage.frame.size.height/2
        
        

        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func btnHidecountry(_ sender: UIButton) {
        
          viewCountry1.isHidden  = true
    }
    
    func releaseKeyboard()
    {
        txtMobile.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtFirstName.resignFirstResponder()
        txtfaceName.resignFirstResponder()
        txttwitterName.resignFirstResponder()
    }
    
    @IBAction func btnSave(_ sender: CustomButton) {
        self.releaseKeyboard()
        if validateForm()
        {
            if(diffstr == "1"){
                 self.editregister()
            }else{
                 self.addregister()
            }
           
        }
    }
    func addregister(){
        let swiftyString = dialcode.replacingOccurrences(of: "+", with: " ")
        var mobile = swiftyString.trim() + txtMobile.text!.trim()
        mobile = mobile.replacingOccurrences(of: " ", with: "")
        
        print(UserDefaults.standard.value(forKey: "userid") as! String)
        print(UserDefaults.standard.value(forKey: "apikey") as! String)
        
        var Parameters = [String: String]()
        Parameters["email"] = txtEmail.text!
        Parameters["fname"] = txtFirstName.text!
        Parameters["lname"] = txtLastName.text!
        Parameters["mobile"] = mobile
        Parameters["facebook"] = txtfaceName.text!
        Parameters["twitter"] = txttwitterName.text!
        
        print(Parameters)
        SVProgressHUD.show()
        Alamofire.request(
            URL_Userprofile ,
            method: .post,
            parameters: Parameters,
            encoding: JSONEncoding(options: []),
            headers:["userid": UserDefaults.standard.value(forKey: "userid") as! String, "apikey": UserDefaults.standard.value(forKey: "apikey") as! String]
            )
            .validate()
            .responseJSON { (response) -> Void in
                SVProgressHUD.dismiss()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    print(success)
                    
                    if(code == 1000){
                        
                        if (self.btnProfileimage.currentImage != UIImage(named: "userIcon.png")) {
                            self.imageregister()
                            
                        }else{
                            
                            
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                            self.navigationController?.popViewController(animated: true)
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
    
    func editregister(){
        
        let swiftyString = dialcode.replacingOccurrences(of: "+", with: " ")
        var mobile = swiftyString.trim() + txtMobile.text!.trim()
        mobile = mobile.replacingOccurrences(of: " ", with: "")
        
        print(UserDefaults.standard.value(forKey: "userid") as! String)
        print(UserDefaults.standard.value(forKey: "apikey") as! String)
        var url  = ""
        var Parameters = [String: String]()
        let str = self.personaldet.value(forKey:"id") as! String
        url = URL_Userprofile + "/" + str
        Parameters["email"] = self.email
        Parameters["fname"] = txtFirstName.text!
        Parameters["lname"] = txtLastName.text!
        Parameters["mobile"] = mobile
      Parameters["facebook"] = txtfaceName.text!
           Parameters["twitter"] = txttwitterName.text!
      
        print(Parameters)
        SVProgressHUD.show()
        Alamofire.request(
            url ,
            method: .put,
            parameters: Parameters,
            encoding: JSONEncoding(options: []),
            headers:["userid": UserDefaults.standard.value(forKey: "userid") as! String, "apikey": UserDefaults.standard.value(forKey: "apikey") as! String]
            )
            .validate()
            .responseJSON { (response) -> Void in
                SVProgressHUD.dismiss()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    print(success)
                    
                    if(code == 1000){
                        
                        if (self.btnProfileimage.currentImage != UIImage(named: "userIcon.png")) {
                            self.imageregister()
                            
                        }else{
                            
                            
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                            self.navigationController?.popViewController(animated: true)
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
        Parameters["roleid"] = "3"
        SVProgressHUD.show()
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
                         headers:["userid": UserDefaults.standard.value(forKey: "userid") as! String,
                                  "apikey":UserDefaults.standard.value(forKey: "apikey") as! String,
                                  "Content-Type":"application/x-www-form-urlencoded"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value as Any)
                    SVProgressHUD.dismiss()
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary)
                        
                        let success = ary.value(forKey: "status") as! NSDictionary
                        let code = success.value(forKey: "code") as! NSNumber
                        if(code == 1000){
                            
                             self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func btnProfileimage(_ sender: UIButton) {
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
   
    
    func validateForm() -> Bool
    {
        var errorMessage  : Bool! = true
        let isValidEmail = Validations.isValidEmailAddress(emailAddressString: txtEmail.text!)
     
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
        if(diffstr != "1"){
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
            
        }
       
        
        //Mobile
        if txtMobile.text!.trim().isNotEmpty && mobilevalid == false
        {
            errorMessage = false
            lblMobileError.text = "Please enter valid mobile number"
            viewMobile.setErrorColor()
        }
        else if txtMobile.text!.trim().isEmpty
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
        txtSearch.resignFirstResponder()
        if(diffstr == "1"){
            if txtFirstName.isFirstResponder
            {
                txtLastName.becomeFirstResponder()
            }
            else if txtLastName.isFirstResponder
            {
                txtMobile.becomeFirstResponder()
            }
            
            else if txtMobile.isFirstResponder
            {
                txtMobile.resignFirstResponder()
            }
        }else{
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
                txtMobile.becomeFirstResponder()
            }
            else if txtMobile.isFirstResponder
            {
                txtfaceName.resignFirstResponder()
            }
            else if txtfaceName.isFirstResponder {
                txttwitterName.becomeFirstResponder()
            }
            else if txttwitterName.isFirstResponder
            {
                txttwitterName.becomeFirstResponder()
            }
        }
      
        
        return false
    }
    func textFieldFocus(_ textField: CustomTextField)
    {
        if(diffstr == "1"){
            if textField == txtFirstName && txtFirstName.text!.trim().isEmpty && !viewFirstName.isErrorColor()
            {
                viewFirstName.setBlackBorder()
            }
            else if textField == txtLastName && txtLastName.text!.trim().isEmpty && !viewLastName.isErrorColor()
            {
                viewLastName.setBlackBorder()
            }
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setBlackBorder()
            }
        }else{
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
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setBlackBorder()
            }
        }
       
        
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        
        if(diffstr == "1"){
            if textField == txtFirstName && txtFirstName.text!.trim().isEmpty && !viewFirstName.isErrorColor()
            {
                viewFirstName.setlighGrayColor()
            }
            else if textField == txtLastName && txtLastName.text!.trim().isEmpty && !viewLastName.isErrorColor()
            {
                viewLastName.setlighGrayColor()
            }
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setlighGrayColor()
            }
        }else{
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
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setlighGrayColor()
            }
        }
      
        
    }
    
    
    
    @objc func keyboardDidShow(_ notification: Notification)
    {
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+30, right: 0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification)
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollview.contentOffset = .zero
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let data = FilterDataArray[indexPath.row]
        print(data)
        cell.lblName.text = "\(data["name"] as! String)"
        cell.lblCode.text = "\(data["dial_code"] as! String)"
        cell.cimg.image = UIImage.init(named: "\(data["code"] as! String)")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
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

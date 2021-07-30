//
//  EditbusinessController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 06/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import FlagPhoneNumber

class EditbusinessController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FPNTextFieldDelegate {
    
    
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: CustomButton!
    @IBOutlet weak var btnProfileimage: UIButton!
    
    @IBOutlet weak var  viewCompanyName: CustomView!
    @IBOutlet weak var  viewEmail: CustomView!
    @IBOutlet weak var  viewMobile: CustomView!
    @IBOutlet weak var  viewAddress: CustomView!
     @IBOutlet weak var  viewSite: CustomView!
    @IBOutlet weak var  viewFacebook: CustomView!
        @IBOutlet weak var  viewTwitter: CustomView!
    @IBOutlet weak var  viewLand: CustomView!
    
    @IBOutlet weak var  txtCompanyName: CustomTextField!
    @IBOutlet weak var  txtMobile: FPNTextField!
    @IBOutlet weak var  txtEmail: CustomTextField!
    @IBOutlet weak var  txtAddress : CustomTextField!
    @IBOutlet weak var  txtSite : CustomTextField!
       @IBOutlet weak var  txtFaceName: CustomTextField!
    @IBOutlet weak var  txtTwitterName: CustomTextField!
     @IBOutlet weak var  txtLand: CustomTextField!
    
    @IBOutlet weak var  lblCompanyError : UILabel!
    @IBOutlet weak var  lblEmailError : UILabel!
    @IBOutlet weak var  lblMobileError : UILabel!
    @IBOutlet weak var  lblAddressError : UILabel!
     @IBOutlet weak var  lblSiteError : UILabel!
    
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
  //  @IBOutlet weak var phonenum: FPNTextField!
    
    weak var activeField: CustomTextField?
    
    var diffstr = ""
    
    
    
    var businessdet : NSDictionary!
    var email = ""
    var dialcode = ""
    var mobilevalid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtMobile.delegate = self
print(self.businessdet)
    
        self.txtMobile.set(phoneNumber: "911234567890")

        if(diffstr == "1"){
            self.txtCompanyName.text = (self.businessdet.value(forKey:"company_name") as! String)
            self.txtAddress.text = (self.businessdet.value(forKey:"address") as! String)
              self.txtSite.text = (self.businessdet.value(forKey:"company_site") as! String)
            self.txtLand.text = (self.businessdet.value(forKey:"landline") as! String)
            self.txtFaceName.text = (self.businessdet.value(forKey:"facebook") as! String)
            self.txtTwitterName.text = (self.businessdet.value(forKey:"twitter") as! String)
            
         //   self.txtMobile.text = (self.businessdet.value(forKey:"company_mobile") as! String)
            self.txtMobile.set(phoneNumber: (self.businessdet.value(forKey:"company_mobile") as! String))

            email = (self.businessdet.value(forKey:"company_email") as! String)

            if let profilepic = self.businessdet["company_logo"] as? String {
                let img = PIMAGE + profilepic
                
                
                
                 self.btnProfileimage.sd_setImage(with: URL(string: img), for: .normal, placeholderImage: UIImage(named: "userIcon.png"))
                
               
            }
            else if (self.businessdet["company_logo"] as? NSNull) != nil {
                
                  btnProfileimage.setImage(UIImage(named:"userIcon.png"), for: .normal)
            }
            
            
            viewEmail.isHidden = true
            viewMobile.frame = CGRect(x: viewMobile.frame.origin.x, y: viewCompanyName.frame.origin.y + viewCompanyName.frame.size.height + 10, width: viewMobile.frame.size.width, height: viewMobile.frame.size.height)
            
            viewLand.frame = CGRect(x: viewLand.frame.origin.x, y: viewMobile.frame.origin.y + viewMobile.frame.size.height + 10, width: viewLand.frame.size.width, height: viewLand.frame.size.height)
            
            
             viewAddress.frame = CGRect(x: viewAddress.frame.origin.x, y: viewLand.frame.origin.y + viewLand.frame.size.height + 10, width: viewAddress.frame.size.width, height: viewAddress.frame.size.height)
            
             viewSite.frame = CGRect(x: viewSite.frame.origin.x, y: viewAddress.frame.origin.y + viewAddress.frame.size.height + 10, width: viewSite.frame.size.width, height: viewSite.frame.size.height)
            
            viewFacebook.frame = CGRect(x: viewFacebook.frame.origin.x, y: viewSite.frame.origin.y + viewSite.frame.size.height + 10, width: viewFacebook.frame.size.width, height: viewFacebook.frame.size.height)
            viewTwitter.frame = CGRect(x: viewTwitter.frame.origin.x, y: viewFacebook.frame.origin.y + viewFacebook.frame.size.height + 10, width: viewTwitter.frame.size.width, height: viewTwitter.frame.size.height)
            
            btnSave.frame = CGRect(x: btnSave.frame.origin.x, y: viewTwitter.frame.origin.y + viewTwitter.frame.size.height + 10, width: btnSave.frame.size.width, height: btnSave.frame.size.height)
             vw.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: vw.frame.size.width, height: btnSave.frame.size.height + btnSave.frame.origin.y+10)
              
            
        }else{
            viewEmail.isHidden = false
             btnProfileimage.setImage(UIImage(named:"userIcon.png"), for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnProfileimage.layer.cornerRadius = btnProfileimage.frame.size.height/2
 
        
         scrollview.contentSize = CGSize(width:self.view.frame.size.width, height: vw.frame.size.height+vw.frame.origin.y)
     
       
        
        // Do any additional setup after loading the view.
    }
    func releaseKeyboard()
    {
        txtMobile.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtCompanyName.resignFirstResponder()
        txtAddress.resignFirstResponder()
         txtSite.resignFirstResponder()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func btnSave(_ sender: CustomButton) {
        self.releaseKeyboard()
        
        
        if validateForm()
        {
            if (self.btnProfileimage.currentImage != UIImage(named: "userIcon.png")) {

                if(diffstr == "1"){
                      self.editregister()
                }else{
                      self.register()
                }



            }else{
                self.view.makeToast("Please Select Profile", duration: 3.0, position: .bottom)
            }

        }
    }
    
    func register(){
        
        let swiftyString = dialcode.replacingOccurrences(of: "+", with: " ")
        var mobile = swiftyString.trim() + txtMobile.text!.trim()
        mobile = mobile.replacingOccurrences(of: " ", with: "")
        
        var Parameters = [String: String]()
        Parameters["email"] = txtEmail.text!
        Parameters["name"] = txtCompanyName.text!
        Parameters["address"] = txtAddress.text!
          Parameters["site"] = txtSite.text!
        Parameters["mobile"] = mobile
        Parameters["lat"] = ""
        Parameters["lng"] = ""

        print(Parameters)
        SVProgressHUD.show()
        Alamofire.request(
            URL_Businessprofile ,
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
                        
                       self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                        self.imageregister()
                        
                        
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
        
        var Parameters = [String: String]()
        Parameters["email"] = email
        Parameters["name"] = txtCompanyName.text!
        Parameters["address"] = txtAddress.text!
        Parameters["site"] = txtSite.text!
        Parameters["mobile"] = mobile
        Parameters["lat"] = ""
        Parameters["lng"] = ""
        var url = ""
        let str = self.businessdet.value(forKey:"id") as! String
        url = URL_Businessprofile + "/" + str
        
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
                        
                        self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                        self.imageregister()
                        
                        
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
        Parameters["roleid"] = "2"
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
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
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
    
    
    func validateForm() -> Bool
    {
        
       
        
        var errorMessage  : Bool! = true
        let isValidEmail = Validations.isValidEmailAddress(emailAddressString: txtEmail.text!)

        if txtCompanyName.text!.trim().isEmpty
        {
            errorMessage = false
            lblCompanyError.text = "Please enter Company  name"
            viewCompanyName.setErrorColor()
        }
        else if txtCompanyName.text!.trim().isNotEmpty && txtCompanyName.text!.trim().count <= 2
        {
            errorMessage = false
            lblCompanyError.text = "Please enter valid Company name"
            viewCompanyName.setErrorColor()
        }
        else{
            lblCompanyError.text = ""
            viewCompanyName.setBlackBorder()
        }
        
        
        if(diffstr != "1"){
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
    }
        //Password
       
        //Mobile
        
        if txtMobile.text!.trim().isEmpty
        {
            errorMessage = false
            lblMobileError.text = "Please enter valid mobile number"
            viewMobile.setErrorColor()
        }else if mobilevalid == false{
            errorMessage = false
            lblMobileError.text = "Please enter valid mobile number"
            viewMobile.setErrorColor()
        }else{
            lblMobileError.text = ""
            viewMobile.setBlackBorder()
        }
        
        //Address
        if txtAddress.text!.trim().isEmpty
        {
            errorMessage = false
            lblAddressError.text = "Please enter last name"
            viewAddress.setErrorColor()
        }
        else if txtAddress.text!.trim().isNotEmpty && txtAddress.text!.trim().count <= 2
        {
            errorMessage = false
            lblAddressError.text = "Please enter valid last name"
            viewAddress.setErrorColor()
        }
        else{
            lblAddressError.text = ""
            viewAddress.setBlackBorder()
        }
        if txtSite.text!.trim().isEmpty
        {
            errorMessage = false
            lblSiteError.text = "Please enter Website url"
            viewEmail.setErrorColor()
        }
        else if txtEmail.text!.trim().isNotEmpty && !isValidEmail
        {
            errorMessage = false
            lblSiteError.text = "Please enter Website url"
            viewEmail.setErrorColor()
        }
        else{
            lblSiteError.text = ""
            viewEmail.setBlackBorder()
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
        
//        if textField == txtMobile {
//
//            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
//
//            let decimalString = components.joined(separator: "") as NSString
//            let length = decimalString.length
//            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//
//            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
//                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
//
//                return (newLength > 10) ? false : true
//            }
            //            var index = 0 as Int
            //            let formattedString = NSMutableString()
            //
            //            if hasLeadingOne {
            //                formattedString.append("1 ")
            //                index += 1
            //            }
            //            if (length - index) > 3 {
            //                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            //                formattedString.appendFormat("(%@)", areaCode)
            //                index += 3
            //            }
            //            if length - index > 3 {
            //                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            //                formattedString.appendFormat("%@-", prefix)
            //                index += 3
            //            }
            //
            //            let remainder = decimalString.substring(from: index)
            //            formattedString.append(remainder)
            //            textField.text = formattedString as String
      //      return true
            
     //   }
            
     //   else {
            return true
     //   }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(diffstr == "1"){
            if txtCompanyName.isFirstResponder
            {
                txtMobile.becomeFirstResponder()
            }
           
            else if txtMobile.isFirstResponder
            {
                txtAddress.becomeFirstResponder()
            }
            else if txtAddress.isFirstResponder
            {
                txtSite.becomeFirstResponder()
            }
            else if txtSite.isFirstResponder
            {
                txtSite.resignFirstResponder()
            }
            
            
        }else{
            if txtCompanyName.isFirstResponder
            {
                txtEmail.becomeFirstResponder()
            }
            else if txtEmail.isFirstResponder
            {
                txtMobile.becomeFirstResponder()
            }
                
            else if txtMobile.isFirstResponder
            {
                txtAddress.becomeFirstResponder()
            }
            else if txtAddress.isFirstResponder
            {
                txtSite.becomeFirstResponder()
            }
            else if txtSite.isFirstResponder
            {
                txtSite.resignFirstResponder()
            }
        }
       
        
        return false
    }
    func textFieldFocus(_ textField: CustomTextField)
    {
        
        if(diffstr == "1"){
            if textField == txtCompanyName && txtCompanyName.text!.trim().isEmpty && !viewCompanyName.isErrorColor()
            {
                viewCompanyName.setBlackBorder()
            }
                
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setBlackBorder()
            }
            else if textField == txtAddress && txtAddress.text!.trim().isEmpty && !viewAddress.isErrorColor()
            {
                viewAddress.setBlackBorder()
            }
            else if textField == txtSite && txtSite.text!.trim().isEmpty && !viewSite.isErrorColor()
            {
                viewSite.setBlackBorder()
            }
            
        }else{
            if textField == txtCompanyName && txtCompanyName.text!.trim().isEmpty && !viewCompanyName.isErrorColor()
            {
                viewCompanyName.setBlackBorder()
            }
                
            else if textField == txtEmail && txtEmail.text!.trim().isEmpty && !viewEmail.isErrorColor()
            {
                viewEmail.setBlackBorder()
            }
                
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setBlackBorder()
            }
            else if textField == txtAddress && txtAddress.text!.trim().isEmpty && !viewAddress.isErrorColor()
            {
                viewAddress.setBlackBorder()
            }
            else if textField == txtSite && txtSite.text!.trim().isEmpty && !viewSite.isErrorColor()
            {
                viewSite.setBlackBorder()
            }
        }
     
        
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        
        if(diffstr == "1"){
            if textField == txtCompanyName && txtCompanyName.text!.trim().isEmpty && !viewCompanyName.isErrorColor()
            {
                viewCompanyName.setlighGrayColor()
            }
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setlighGrayColor()
            }
            else if textField == txtAddress && txtAddress.text!.trim().isEmpty && !viewAddress.isErrorColor()
            {
                viewAddress.setlighGrayColor()
            }
            else if textField == txtSite && txtSite.text!.trim().isEmpty && !viewSite.isErrorColor()
            {
                viewSite.setlighGrayColor()
            }
        }else{
            if textField == txtCompanyName && txtCompanyName.text!.trim().isEmpty && !viewCompanyName.isErrorColor()
            {
                viewCompanyName.setlighGrayColor()
            }
            else if textField == txtEmail && txtEmail.text!.trim().isEmpty && !viewEmail.isErrorColor()
            {
                viewEmail.setlighGrayColor()
            }
                
            else if textField == txtMobile && txtMobile.text!.trim().isEmpty && !viewMobile.isErrorColor()
            {
                viewMobile.setlighGrayColor()
            }
            else if textField == txtAddress && txtAddress.text!.trim().isEmpty && !viewAddress.isErrorColor()
            {
                viewAddress.setlighGrayColor()
            }
            else if textField == txtSite && txtSite.text!.trim().isEmpty && !viewSite.isErrorColor()
            {
                viewSite.setlighGrayColor()
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

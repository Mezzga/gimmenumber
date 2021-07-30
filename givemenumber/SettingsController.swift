//
//  SettingsController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 05/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//
import SafariServices
import UIKit
import Alamofire
import SVProgressHUD
import ContactsUI

class SettingsController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CNContactViewControllerDelegate,SFSafariViewControllerDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var btnSignout: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var viewBusiness: UIView!
    @IBOutlet weak var viewSubbusiness: UIView!
    @IBOutlet weak var viewBuscart: UIView!
    @IBOutlet weak var lblBusname: UILabel!
    @IBOutlet weak var lblBusadd: UILabel!
    @IBOutlet weak var lblBusnum: UILabel!
    @IBOutlet weak var lblBusemail: UILabel!
    @IBOutlet weak var lblBusweb: UILabel!
    @IBOutlet weak var btnBusShare: UIButton!
    @IBOutlet weak var btnBusCancel: UIButton!
    @IBOutlet weak var btnBushide: UIButton!
    @IBOutlet weak var imgBusprofile: UIImageView!
    @IBOutlet weak var viewExport: UIView!
    @IBOutlet weak var viewSubexport: UIView!
    @IBOutlet weak var btnExpsubmit: UIButton!
    @IBOutlet weak var btnExpcancel: UIButton!
    @IBOutlet weak var viewExppassword: CustomView!
    @IBOutlet weak var lblExperrorpass: UILabel!
    @IBOutlet weak var txtExppass: CustomTextField!
    weak var activeField: CustomTextField?
    @IBOutlet weak var btnExphide: UIButton!
 var lineitemary = Array<Any>()
    var store: CNContactStore!
    
  //  var contactdet:NSDictionary = [:]
    
    var userdet: NSArray = []

    var titles = ["My Profile","My Contacts","Import Contact to App","Export Contact to Phone","Settings","Change Password","Share My Business Card","Share Other Contacts","Privacy Policy"]
    
    var images = ["user.png","mycontacts.png","import.png","exporte.png","setting.png","password.png","buscard.png","sharecontact.png","privacy.png"]
    
    var businessdet:NSDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        store = CNContactStore()

       
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        imgBusprofile.layer.cornerRadius = imgBusprofile.frame.size.height/2
        
        viewBuscart.layer.cornerRadius = 10
        viewSubbusiness.layer.cornerRadius = 10
        btnBusShare.layer.cornerRadius = 8
        btnBusCancel.layer.cornerRadius = 8
        btnSignout.layer.cornerRadius = 8
        
        viewBuscart.layer.shadowColor = UIColor.lightGray.cgColor
        viewBuscart.layer.shadowOpacity = 1
        viewBuscart.layer.shadowOffset = CGSize.zero
        viewBuscart.layer.shadowRadius = 5
        viewBuscart.layer.cornerRadius = 5
        
        btnExpcancel.layer.cornerRadius = 8
        btnExpsubmit.layer.cornerRadius = 8
        
        viewSubexport.layer.shadowColor = UIColor.lightGray.cgColor
        viewSubexport.layer.shadowOpacity = 1
        viewSubexport.layer.shadowOffset = CGSize.zero
        viewSubexport.layer.shadowRadius = 5
        viewSubexport.layer.cornerRadius = 5
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        lblVersion.text = "Version" + appVersion!

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController!.selectedIndex = 3

        viewBusiness.isHidden = true
        viewExport.isHidden = true
        self.getuserdet()
    }
    @IBAction func btnExphide(_ sender: UIButton) {
        self.view.endEditing(true)
        viewExport.isHidden = true
    }
    @IBAction func btnExpsubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateForm(){
            self.exportapi()
        }
        
    }
    
    @IBAction func btnExpcancel(_ sender: UIButton) {
         self.view.endEditing(true)
        viewExport.isHidden = true
    }
    
    @IBAction func btnBuscancel(_ sender: UIButton) {
         viewBusiness.isHidden = true
    }
    
    @IBAction func btnBusshare(_ sender: UIButton) {
        
        let img = UIImageView()
    UIGraphicsBeginImageContextWithOptions(viewBuscart.bounds.size, viewBuscart.isOpaque, 0.0)
        viewBuscart.drawHierarchy(in: viewBuscart.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print(image as Any)
        img.image = image
        
        let image1 = img.image
        let shareAll = ["Give Me Your Number", image1 as Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
      
    }
    
     func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    @IBAction func btnBushide(_ sender: UIButton) {
        viewBusiness.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getuserdet(){
        let url = URL_Getuserprofile + "?" + "userid=" + (UserDefaults.standard.value(forKey: "userid") as! String)
        Alamofire.request(
            url ,
            method: .get,
            headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String),
                "Content-Type":"application/x-www-form-urlencoded"]
            )
            .validate()
            .responseJSON { (response) -> Void in
                SVProgressHUD.dismiss()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    
                    if(code == 1000){
                        
                        self.businessdet = ary.value(forKey: "business_profile") as! NSDictionary
        
                            if(self.businessdet.count>0){
                                self.lblBusname.text = (self.businessdet.value(forKey:"company_name") as! String)
                                self.lblBusadd.text = (self.businessdet.value(forKey:"address") as! String)
                                self.lblBusnum.text = (self.businessdet.value(forKey:"company_mobile") as! String)
                                
                                self.lblBusemail.text = (self.businessdet.value(forKey:"company_email") as! String)
                                self.lblBusweb.text = (self.businessdet.value(forKey:"company_site") as! String)
                                
                                if let profilepic = self.businessdet["company_logo"] as? String {
                                    self.imgBusprofile.sd_setImage(with: URL(string:PIMAGE + (profilepic)), placeholderImage: UIImage(named: "userIcon.png"))
                                }
                                else if (self.businessdet["company_logo"] as? NSNull) != nil {
                                    
                                    self.imgBusprofile.image = UIImage(named: "userIcon.png")
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
    
    @IBAction func btnSignout(_ sender: CustomButton) {
        
        SVProgressHUD.show()
        Alamofire.request(
            URL_Logout ,
            method: .post,
            headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String),
                "Content-Type":"application/x-www-form-urlencoded"]
            )
            .validate()
            .responseJSON { (response) -> Void in
                SVProgressHUD.dismiss()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    
                    if(code == 1000){
                        
                        UserDefaults.standard.removeObject(forKey: "userid")
                        UserDefaults.standard.removeObject(forKey: "apikey")
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cellReuseIdentifier = "SettingCell"
        
        let cell: SettingCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SettingCell
    

        cell.selectionStyle = .none
        cell.lblTitle.text = titles[indexPath.row]
        
       
        
       cell.img.image = UIImage(named: images[indexPath.row])!
       
        
        return cell
    }
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            self.view.endEditing(true)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row == 1){
            self.view.endEditing(true)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MycontactlistController") as! MycontactlistController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if(indexPath.row == 2){
            
            lineitemary = NSArray() as! [Any]
            
            let contacts = self.getContactFromCNContact()
            for contact in contacts {
                let MobNumVar = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
                
                var email = ""
                for mail in contact.emailAddresses {
                    email = mail.value as String
                }
                let name = contact.givenName + " " + contact.familyName
                
                let foundation = NSMutableDictionary()
                foundation.setValue(name , forKey: "name")
                foundation.setValue(email, forKey: "email")
                foundation.setValue(MobNumVar, forKey: "mobile")
                //            print(contact.middleName)
                //            print(contact.familyName)
                //            print(contact.givenName)
                //     print(contact.phoneNumbers)
                self.lineitemary.append(foundation)
                
            }
            
            print(self.lineitemary)
            self.savecontact()
            
        }
        
        if(indexPath.row == 3){
         txtExppass.text = ""
         viewExport.isHidden = false
        }
        if(indexPath.row == 4){
            self.view.endEditing(true)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if(indexPath.row == 5){
            self.view.endEditing(true)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChangepasswordController") as! ChangepasswordController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row == 6){
            if(self.businessdet.count>0){
                self.viewBusiness.isHidden = false
            }else{
          self.view.makeToast("No Business cart available", duration: 3.0, position: .bottom)
                
            }
        }
        if(indexPath.row == 7){
            self.view.endEditing(true)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SharecontactsController") as! SharecontactsController
            self.navigationController?.pushViewController(vc, animated: true)
        }
         if(indexPath.row == 8){
            let svc = SFSafariViewController(url: URL(string: "http://geniefinserv.in/gimme/privacy_policy.html")!)
                       svc.delegate = self
                       present(svc, animated: false, completion: nil)
        }
    }
    
    func getContactFromCNContact() -> [CNContact] {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            ] as [Any]
        
        //Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
                
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }
    func savecontact(){
        var myJsonString : String!
        do {
            let data =  try JSONSerialization.data(withJSONObject:lineitemary, options: .prettyPrinted)
            myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
        }
        
        SVProgressHUD.show()
        let json = myJsonString
        let jsonData = json?.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: URL(string: URL_Contact)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue((UserDefaults.standard.value(forKey: "userid") as! String),forHTTPHeaderField: "userid")
        request.setValue((UserDefaults.standard.value(forKey: "apikey") as! String),forHTTPHeaderField: "apikey")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            SVProgressHUD.dismiss()
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
        
        
        //   print(myJsonString)
    }
    
    func validateForm() -> Bool
    {
        var errorMessage  : Bool! = true 
        if txtExppass.text!.trim().isEmpty
        {
            errorMessage = false
            viewExppassword.setErrorColor()
            lblExperrorpass.text = "Please enter a password"
        }
        else if txtExppass.text!.trim().count < 8
        {
            errorMessage = false
            viewExppassword.setErrorColor()
            lblExperrorpass.text = "Please enter a valid password"
        }
        else{
            lblExperrorpass.text = ""
            viewExppassword.setBlackBorder()
        }
        return errorMessage
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldResignFocus((textField as? CustomTextField)!)
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField as? CustomTextField
        self.textFieldFocus(activeField!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
            txtExppass.resignFirstResponder()
        
        return false
    }
    
    func textFieldFocus(_ textField: CustomTextField)
    {
       
        if textField == txtExppass && txtExppass.text!.trim().isEmpty && !viewExppassword.isErrorColor()
        {
            txtExppass.placeholder = "Password (Min. 8 characters)"
            viewExppassword.setBlackBorder()
        }
    }
    func textFieldResignFocus(_ textField: CustomTextField)
    {
        if textField == txtExppass && txtExppass.text!.trim().isEmpty && !viewExppassword.isErrorColor(){
            viewExppassword.setlighGrayColor()
            txtExppass.placeholderLabel.text = "Password"
        }
    }
    
    func exportapi(){
        var Parameters = [String: String]()
        Parameters["password"] = txtExppass.text!
        SVProgressHUD.show()
        Alamofire.request(
            URL_Validateuser ,
            method: .post,
            parameters: Parameters,
            headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String),
                "Content-Type":"application/x-www-form-urlencoded"]
            )
            .validate()
            .responseJSON { (response) -> Void in
                SVProgressHUD.dismiss()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    
                    if(code == 1000){
                        self.viewExport.isHidden = true
                        self.getcontacts()
                       
                       
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
    
    func getcontacts(){
        
        userdet = NSArray()
        let url = URL_Contact + "?" + "limit=1000&page=0"
        SVProgressHUD.show()
        Alamofire.request(
            url ,
            method: .get,
            headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey": (UserDefaults.standard.value(forKey: "apikey") as! String),
                "Content-Type":"application/x-www-form-urlencoded"]
            )
            .validate()
            .responseJSON { (response) -> Void in
                SVProgressHUD.dismiss()
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    
                    if(code == 1000){
                        self.userdet = ary.value(forKey: "result") as! NSArray
//                        if(userary.count>0){
//                            self.contactdet = userary.mutableCopy() as! NSDictionary
//                        }
                        if(self.userdet.count>0){
                             self.saveContact()
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
    
    
    


func saveContact(){
    DispatchQueue.main.async {

        for  index in 0...self.userdet.count-1{
            let dic = (self.userdet[index] as! NSDictionary).mutableCopy() as! NSMutableDictionary

        let store = CNContactStore()
        OperationQueue().addOperation{[store] in
            let mobileNumber = CNPhoneNumber(stringValue: (dic["mobile"] as! String))
            
            let predicate = CNContact.predicateForContacts(matching: mobileNumber)
            //    let predicate = CNContact.predicateForContacts(matchingName: "Johnny")
            
            let toFetch = [CNContactPhoneNumbersKey, CNContactGivenNameKey,CNContactEmailAddressesKey,CNContactFamilyNameKey]
            
            do{
                let contacts = try store.unifiedContacts(matching: predicate,
                                                         keysToFetch: toFetch as [CNKeyDescriptor])
                print(contacts)
                if(contacts == []){
                    print("newone")
                    let contactToAdd = CNMutableContact()
                    contactToAdd.givenName = (dic["name"] as! String)
                    contactToAdd.familyName = ""
                    let workEmailEntry : String = (dic["email"] as! String)
                    let email = CNLabeledValue(label: CNLabelWork, value: workEmailEntry as NSString)
                    contactToAdd.emailAddresses = [email]
                    let mobileNumber = CNPhoneNumber(stringValue: (dic["mobile"] as! String))
                    let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                    contactToAdd.phoneNumbers = [mobileValue]
                    let saveRequest = CNSaveRequest()
                    saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
                    do {
                        try store.execute(saveRequest)
                    } catch {
                        print(error)
                    }
                }
                else{
                    print("already one")
                    for Contact in contacts{
                        let contactToAdd = Contact.mutableCopy() as! CNMutableContact
                       // print(contactToAdd.phoneNumbers)
                        contactToAdd.givenName = (dic["name"] as! String)
                        contactToAdd.familyName = ""
                        let workEmailEntry : String = (dic["email"] as! String)
                        let email = CNLabeledValue(label: CNLabelWork, value: workEmailEntry as NSString)
                        contactToAdd.emailAddresses = [email]
                        let mobileNumber = CNPhoneNumber(stringValue: (dic["mobile"] as! String))
                        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                        contactToAdd.phoneNumbers = [mobileValue]
                        let saveRequest = CNSaveRequest()
                        saveRequest.update(contactToAdd)
                        do {
                            try store.execute(saveRequest)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            catch let err{
                print(err)
            }
        }
        
        }
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

//
//  ContactslistController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 12/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//
import ContactsUI
import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import MessageUI

class ContactslistController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate  {

    var userdet1: NSArray = []
    var store: CNContactStore!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnTake: CustomButton!
    @IBOutlet weak var btnGiveme: CustomButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var ViewSubdet: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnPhonenum: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet weak var btnTakeothers: CustomButton!

    var userdet: NSMutableArray = []
    var type = ""
    var page = 0
    var limit = 10
    var indexid = 0
    
    var businessdet:NSDictionary = [:]
    var personaldet:NSDictionary = [:]
    
    var profilediffstr = ""
    var sendemail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
         store = CNContactStore()
        viewDetails.isHidden = true
        ViewSubdet.layer.cornerRadius = 8
        btnProfile.setImage(UIImage(named: "business.png"), for: .normal)
        
    
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       UserDefaults.standard.removeObject(forKey: "contactcount")
       self.tabBarController?.tabBar.items?[2].badgeValue = nil
        tabBarController!.selectedIndex = 2
        page = 0
        limit = 10
        userdet = NSMutableArray()
        table.reloadData()
        if(type == "2"){
            type = "2"
            btnGiveme.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
            btnGiveme.setTitleColor(UIColor.white, for: .normal)
            
            btnTake.backgroundColor = UIColor.white
            btnTake.setTitleColor(UIColor.black, for: .normal)
            btnTakeothers.backgroundColor = UIColor.white
            btnTakeothers.setTitleColor(UIColor.black, for: .normal)
        }else if(type == "3"){
            type = "3"
            btnTakeothers.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
            btnTakeothers.setTitleColor(UIColor.white, for: .normal)
            
            btnTake.backgroundColor = UIColor.white
            btnTake.setTitleColor(UIColor.black, for: .normal)
            btnGiveme.backgroundColor = UIColor.white
            btnGiveme.setTitleColor(UIColor.black, for: .normal)
        }else{
            type = "1"
            btnTake.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
            btnTake.setTitleColor(UIColor.white, for: .normal)
            
            btnGiveme.backgroundColor = UIColor.white
            btnGiveme.setTitleColor(UIColor.black, for: .normal)
            btnTakeothers.backgroundColor = UIColor.white
            btnTakeothers.setTitleColor(UIColor.black, for: .normal)
           
        }
        self.getuserprofile()
    }
    @IBAction func btnHide(_ sender: Any) {
        viewDetails.isHidden = true
    }
    @IBAction func btnProfile(_ sender: Any) {
        if(profilediffstr == "1"){
           
            if(personaldet.count>0){
                btnProfile.setImage(UIImage(named: "profile.png"), for: .normal)

                 profilediffstr = "2"
            self.lblName.text = (self.personaldet.value(forKey:"name") as! String) + (self.personaldet.value(forKey:"lname") as! String)
                self.sendemail = (self.personaldet.value(forKey:"email") as! String)
                self.btnPhonenum.setTitle((self.personaldet.value(forKey:"mobile") as! String), for: .normal)
      //      self.btnPhonenum.text = (self.personaldet.value(forKey:"mobile") as! String)
            if let profilepic = self.personaldet["profile_pic"] as? String {
                let img = PIMAGE + profilepic
                
                self.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "userIcon.png"))
            }
            else if (self.personaldet["profile_pic"] as? NSNull) != nil {
                
                self.img.image = UIImage(named: "userIcon.png")
            }
            }
        }else{
             if(businessdet.count>0){
                btnProfile.setImage(UIImage(named: "business.png"), for: .normal)

            profilediffstr = "1"
                self.sendemail = (self.businessdet.value(forKey:"company_email") as! String)
            
            self.lblName.text = (self.businessdet.value(forKey:"company_name") as! String)
        self.btnPhonenum.setTitle((self.businessdet.value(forKey:"company_mobile") as! String), for: .normal)
            
            if let profilepic = self.businessdet["company_logo"] as? String {
                self.img.sd_setImage(with: URL(string:PIMAGE + (profilepic)), placeholderImage: UIImage(named: "userIcon.png"))
            }
            else if (self.businessdet["company_logo"] as? NSNull) != nil {
                
                self.img.image = UIImage(named: "userIcon.png")
            }
        }
        }
    }
    
    @IBAction func btnEmail(_ sender: Any) {
        viewDetails.isHidden = true
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.sendemail])
        mailComposeVC.setSubject("Give Me Number")
     //   mailComposeVC.setMessageBody("", isHTML: false)
        self.present(mailComposeVC, animated: true, completion: nil)

    }
    @IBAction func btnPhonenum(_ sender: Any) {

        if let phoneCallURL = URL(string: "tel://\(btnPhonenum.titleLabel!.text as! String)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnTake(_ sender: CustomButton) {
        
        
        btnTake.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
        btnTake.setTitleColor(UIColor.white, for: .normal)
        
        btnGiveme.backgroundColor = UIColor.white
        btnGiveme.setTitleColor(UIColor.black, for: .normal)
        btnTakeothers.backgroundColor = UIColor.white
        btnTakeothers.setTitleColor(UIColor.black, for: .normal)
        
        page = 0
        limit = 10
        type = "1"
        userdet = NSMutableArray()
        table.reloadData()
        self.getuserprofile()
    }
    
    @IBAction func btnGiveme(_ sender: CustomButton) {
        
        btnGiveme.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
        btnGiveme.setTitleColor(UIColor.white, for: .normal)
        
        btnTake.backgroundColor = UIColor.white
        btnTake.setTitleColor(UIColor.black, for: .normal)
        btnTakeothers.backgroundColor = UIColor.white
        btnTakeothers.setTitleColor(UIColor.black, for: .normal)
        page = 0
        limit = 10
        type = "2"
        userdet = NSMutableArray()
        table.reloadData()
        self.getuserprofile()
    }
    @IBAction func btnTakeothers(_ sender: CustomButton) {
        
        btnTakeothers.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
        btnTakeothers.setTitleColor(UIColor.white, for: .normal)
        
        btnTake.backgroundColor = UIColor.white
        btnTake.setTitleColor(UIColor.black, for: .normal)
        btnGiveme.backgroundColor = UIColor.white
        btnGiveme.setTitleColor(UIColor.black, for: .normal)
        page = 0
        limit = 10
        type = "3"
        userdet = NSMutableArray()
        table.reloadData()
        self.getuserprofile()
    }
    
    func getuserprofile(){
        
        if(self.userdet.count>0){
            self.table.reloadData()
            self.table.isHidden = false
            self.lblEmpty.isHidden = true
        }else{
            self.table.isHidden = true
            self.lblEmpty.isHidden = false
        }
        if(page == 0){
            SVProgressHUD.show()

        }
        
        var Parameters = [String: Any]()
        Parameters["type"] = type
        Parameters["page"] = page
        Parameters["limit"] = limit
           if (UserDefaults.standard.value(forKey: "personalclick") != nil) {
                 Parameters["roleid"] = "3"
           }
           else{
                Parameters["roleid"] = "2"
           }
        print(Parameters)
        Alamofire.request(
            URL_Getaccept ,
            method: .post,
            parameters: Parameters,
            encoding: JSONEncoding(options: []),
            headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey": (UserDefaults.standard.value(forKey: "apikey") as! String)]
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
                        let userary = ary.value(forKey: "result") as! NSArray
                        if(userary.count>0){
                            if self.type == "2" {
                                self.userdet1 = NSArray()
                                self.userdet1 = ary.value(forKey: "result") as! NSArray
                                self.saveContact()
                            }
                          
                            
                            
                            self.userdet.addObjects(from: userary as! [Any])
                        }
                        if(self.userdet.count>0){
                            self.table.reloadData()
                            self.table.isHidden = false
                            self.lblEmpty.isHidden = true
                        }else{
                            self.table.isHidden = true
                            self.lblEmpty.isHidden = false
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = (userdet[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        let cellReuseIdentifier = "ListCell"
        
        let cell: ListCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ListCell
        
        cell.selectionStyle = .none
        cell.vw.layer.cornerRadius = 5
        cell.vw.layer.shadowRadius = 5
        cell.vw.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.vw.layer.shadowOpacity = 1
        cell.vw.layer.shadowColor = UIColor.lightGray.cgColor
        cell.lblName.text = (dic["name"] as! String)
        cell.lblDate.text = (dic["mobile"] as! String)

        if let profilepic = dic["profile_pic"] as? String {
            let imgstr = PIMAGE + profilepic
            
            cell.imgProfile.sd_setImage(with: URL(string: imgstr), placeholderImage: UIImage(named: "ic_avatar_home.png"))
        }
        else if (dic["profile_pic"] as? NSNull) != nil {
            
            cell.imgProfile.image = UIImage(named: "ic_avatar_home.png")
        }
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
//        if(self.type == "1"){
//            cell.lblDate.isHidden = true
//        }else{
//            cell.lblDate.isHidden = false
//        }
//        
        
        
        let limits = (page*limit) + 10
        if (indexPath.row == userdet.count-1) {
            if (limits <= userdet.count) {
                page = page + 1;
                self.getuserprofile()
            }
        }
        
        return cell
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexid = indexPath.row
        self.getuserdet()
    }
    func getuserdet(){
        let dic = (userdet[indexid] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        SVProgressHUD.show()
        
        let url = URL_Getuserprofile + "?" + "userid=" + (dic["uid"] as! String)
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
                        self.personaldet = ary.value(forKey: "personal_profile") as! NSDictionary
                        
                        if(self.businessdet.count>0 || self.personaldet.count>0){
                            self.viewDetails.isHidden = false
                            if(self.businessdet.count>0){
                                self.btnProfile.setImage(UIImage(named: "business.png"), for: .normal)

                                self.profilediffstr = "1"
                                self.sendemail = (self.businessdet.value(forKey:"company_email") as! String)
                                self.lblName.text = (self.businessdet.value(forKey:"company_name") as! String)
                                self.btnPhonenum.setTitle((self.businessdet.value(forKey:"company_mobile") as! String), for: .normal)
                              
                                if let profilepic = self.businessdet["company_logo"] as? String {
                                    self.img.sd_setImage(with: URL(string:PIMAGE + (profilepic)), placeholderImage: UIImage(named: "userIcon.png"))
                                }
                                else if (self.businessdet["company_logo"] as? NSNull) != nil {
                                    
                                    self.img.image = UIImage(named: "userIcon.png")
                                }
                            }else{
                                self.btnProfile.setImage(UIImage(named: "profile.png"), for: .normal)

                                self.profilediffstr = "2"
                                self.sendemail = (self.personaldet.value(forKey:"email") as! String)
                                self.lblName.text = (self.personaldet.value(forKey:"name") as! String) + (self.personaldet.value(forKey:"lname") as! String)
                                self.btnPhonenum.setTitle((self.personaldet.value(forKey:"mobile") as! String), for: .normal)
                                if let profilepic = self.personaldet["profile_pic"] as? String {
                                    let img = PIMAGE + profilepic
                                    
                                    self.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "userIcon.png"))
                                }
                                else if (self.personaldet["profile_pic"] as? NSNull) != nil {
                                    
                                    self.img.image = UIImage(named: "userIcon.png")
                                }
                                
                            }
                        }else{
                            self.viewDetails.isHidden = true
                        }
                        
                        if(self.businessdet.count>0){
                            if(self.personaldet.count>0){
                                
                            }
                        }
                        
                        if(self.personaldet.count>0){
                            if(self.businessdet.count>0){
                                
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
    
    
    
    func saveContact(){
        DispatchQueue.main.async {
            
            for  index in 0...self.userdet1.count-1{
                let dic = (self.userdet1[index] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
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

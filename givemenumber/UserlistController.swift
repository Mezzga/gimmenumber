//
//  UserlistController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 10/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//
import ContactsUI
import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage


class UserlistController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnTake: CustomButton!
    @IBOutlet weak var btnGiveme: CustomButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var btnTakeothers: CustomButton!
 var userdet1: NSArray = []
      var store: CNContactStore!
    var userdet: NSMutableArray = []
    var type = ""
    var page = 0
    var limit = 10
    
    var status = ""
    var indexid = 0

    override func viewDidLoad() {
        super.viewDidLoad()
         store = CNContactStore()
        table.separatorStyle = UITableViewCell.SeparatorStyle.none


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserDefaults.standard.removeObject(forKey: "usercount")
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        tabBarController!.selectedIndex = 1
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
        limit = 100
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
            if (UserDefaults.standard.value(forKey: "personalclick") != nil) {
                 Parameters["roleid"] = "3"
           }
           else{
                Parameters["roleid"] = "2"
           }
        Parameters["limit"] = limit
         Parameters["status"] = "0"
        print(Parameters)
        Alamofire.request(
            URL_Getrequest ,
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
        
        if let profilepic = dic["profile_pic"] as? String {
            let imgstr = PIMAGE + profilepic
            
            cell.imgProfile.sd_setImage(with: URL(string: imgstr), placeholderImage: UIImage(named: "ic_avatar_home.png"))
        }
        else if (dic["profile_pic"] as? NSNull) != nil {
            
            cell.imgProfile.image = UIImage(named: "ic_avatar_home.png")
        }
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.btnAccept.layer.cornerRadius = 20
        cell.btnReject.layer.cornerRadius = 20
        
        
        let timeStamp = Double(dic["updateDate"] as! String)
        let unixTimeStamp: Double = timeStamp!
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let dateFormatt = DateFormatter();
        dateFormatt.dateFormat = "MMM yyyy dd hh:mm a"
        cell.lblDate.text = dateFormatt.string(from: exactDate as Date)
        
        cell.btnAccept.tag = indexPath.row
        cell.btnAccept.addTarget(self, action:#selector(self.btnAccept(_sender:)), for: .touchUpInside)
        
        cell.btnReject.tag = indexPath.row
        cell.btnReject.addTarget(self, action:#selector(self.btnReject(_sender:)), for: .touchUpInside)
        
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
        return 200
    }

    
    @objc func btnAccept(_sender: UIButton){
        indexid = _sender.tag
        status = "1"
        if(type == "3"){
             self.acceptapi1()
        }else{
             self.acceptapi()
        }
       
    }
    
    @objc func btnReject(_sender: UIButton){
        indexid = _sender.tag
        status = "2"
        if(type == "3"){
            self.acceptapi1()
        }else{
            self.acceptapi()
        }
    }
    
    func acceptapi(){
        let dic = (userdet[indexid] as! NSDictionary).mutableCopy() as! NSMutableDictionary
       
        var url = ""
        url = URL_Request + "/" + (dic["id"] as! String)
        SVProgressHUD.show()
        var Parameters = [String: Any]()
        Parameters["status"] = status
        print(Parameters)
        Alamofire.request(
            url ,
            method: .put,
            parameters: Parameters,
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
                        if(self.type == "1"){
                        self.userdet1 = NSArray()
                        self.userdet1 = ary.value(forKey: "user") as! NSArray
                            self.saveContact()
                        }
                        self.userdet.removeObject(at: self.indexid)
                        self.table.reloadData()
                        if(self.userdet.count>0){
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
    
    func acceptapi1(){
        let dic = (userdet[indexid] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        var url = ""
        url = URL_Sharerequest + "/" + (dic["id"] as! String)
        SVProgressHUD.show()
        var Parameters = [String: Any]()
        Parameters["status"] = status
        if ((dic["profile_pic"]) != nil) {
             Parameters["type"] = "3"
        }
        else {
              Parameters["type"] = "4"
        }
        
       
        
        print(Parameters)
        Alamofire.request(
            url ,
            method: .put,
            parameters: Parameters,
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
                        self.userdet1 = NSArray()
                        self.userdet1 = ary.value(forKey: "user") as! NSArray
                        self.saveContact()
                        self.userdet.removeObject(at: self.indexid)
                        self.table.reloadData()
                        if(self.userdet.count>0){
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

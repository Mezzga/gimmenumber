//
//  MycontactlistController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 12/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Contacts

class MycontactlistController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblEmpty: UILabel!
    var userdet: NSMutableArray = []
    var page = 0
    var limit = 10
    var lineitemary = Array<Any>()
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        table.separatorStyle = UITableViewCell.SeparatorStyle.none

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        page = 0
        limit = 10
        self.userdet = NSMutableArray()
        self.table.reloadData()
        self.getcontacts()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSync(_ sender: UIButton) {
        
        
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
            self.page = 0
            self.limit = 10
            self.userdet = NSMutableArray()
            self.table.reloadData()
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
    
        
     //   print(myJsonString)
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
         self.userdet = NSMutableArray()
        self.getcontacts()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.userdet = NSMutableArray()
        self.getcontacts()
    }
    func getcontacts(){
        
        if(self.userdet.count>0){
            self.table.reloadData()
            self.table.isHidden = false
            self.lblEmpty.isHidden = true
        }else{
            self.table.isHidden = true
            self.lblEmpty.isHidden = false
        }
        let param = "limit=" + String(limit) + "&page=" + String(page) + "&search=" + String(searchBar.text!)
        let url = URL_Contact + "?" + param
        
        print(url)
        
        if(page == 0){
            SVProgressHUD.show()
        }
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
        
        let cellReuseIdentifier = "ContactsCell"
        
        let cell: ContactsCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCell
        
        cell.selectionStyle = .none
        cell.vw.layer.cornerRadius = 5
        cell.vw.layer.shadowRadius = 5
        cell.vw.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.vw.layer.shadowOpacity = 1
        cell.vw.layer.shadowColor = UIColor.lightGray.cgColor
        cell.lblName.text = (dic["name"] as! String)
        cell.lblNumber.text = (dic["mobile"] as! String)
        
        cell.btnCall.tag = indexPath.row
        cell.btnCall.addTarget(self, action: #selector(self.btnAccept(_sender:)), for: .touchUpInside)

        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(self.btnShare(_sender:)), for: .touchUpInside)
        
        
        let limits = (page*limit) + 10
        if (indexPath.row == userdet.count-1) {
            if (limits <= userdet.count) {
                page = page + 1;
                self.getcontacts()
            }
        }
        
        return cell
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
        @objc func btnShare(_sender: UIButton){
            let dic = (userdet[_sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SharecontactsController") as! SharecontactsController
            vc.generalstr = "1"
            vc.shareid = (dic["id"] as! String)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
    }
    
    
    @objc func btnAccept(_sender: UIButton){
        let dic = (userdet[_sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let phoneNumber = (dic["mobile"] as! String)
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
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

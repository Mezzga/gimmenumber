//
//  ProfileController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 05/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD

class ProfileController: UIViewController {
    
    @IBOutlet weak var lblPerprofile: UILabel!
    @IBOutlet weak var lblBusinessprofile: UILabel!
    @IBOutlet weak var btnPerprofile: UIButton!
    @IBOutlet weak var btnBusinessprofile: UIButton!
    @IBOutlet weak var btnAddpersonal: CustomButton!
    @IBOutlet weak var btnAddbusiness: CustomButton!
    @IBOutlet weak var viewPersonal: UIView!
    @IBOutlet weak var viewBusiness: UIView!
    @IBOutlet weak var lblPername: UILabel!
    @IBOutlet weak var lblPermobile: UILabel!
    @IBOutlet weak var lblPeremail: UILabel!
    @IBOutlet weak var lblPerface: UILabel!
    @IBOutlet weak var lblPertwitter: UILabel!
    
    @IBOutlet weak var lblBusname: UILabel!
    @IBOutlet weak var lblBusaddress: UILabel!
    @IBOutlet weak var lblBusmobile: UILabel!
    @IBOutlet weak var lblBusemail: UILabel!
    @IBOutlet weak var lblBusweb: UILabel!
     @IBOutlet weak var lblBusland: UILabel!
    @IBOutlet weak var lblBusface: UILabel!
    @IBOutlet weak var lblBustwitter: UILabel!
    
    @IBOutlet weak var imgBusprofile: UIImageView!
    @IBOutlet weak var imgPerprofile: UIImageView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var viewPer: UIView!
    @IBOutlet weak var viewBus: UIView!
    @IBOutlet weak var personalswitch : UISwitch!
      @IBOutlet weak var businessswitch : UISwitch!
    var businessdet:NSDictionary = [:]
    var personaldet:NSDictionary = [:]

    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollview.contentSize = CGSize(width: scrollview.frame.size.width, height: vw.frame.size.height)
        
//        if(UserDefaults.standard.value(forKey: "roleid")as! String == "2"){
//            lblBusemail.text = (UserDefaults.standard.value(forKey: "email")as! String)
//            lblPeremail.text = (UserDefaults.standard.value(forKey: "alt_email")as! String)
//        }else{
//            lblBusemail.text = (UserDefaults.standard.value(forKey: "alt_email")as! String)
//            lblPeremail.text = (UserDefaults.standard.value(forKey: "email")as! String)
//        }
        personalswitch.addTarget(self, action: #selector(perswitch(_sender:)), for: .valueChanged)
        businessswitch.addTarget(self, action: #selector(busswitch(_sender:)), for: .valueChanged)
        viewBusiness.layer.shadowColor = UIColor.lightGray.cgColor
        viewBusiness.layer.shadowOpacity = 1
        viewBusiness.layer.shadowOffset = CGSize.zero
        viewBusiness.layer.shadowRadius = 5
        viewBusiness.layer.cornerRadius = 5
        
        
        viewPersonal.layer.shadowColor = UIColor.lightGray.cgColor
        viewPersonal.layer.shadowOpacity = 1
        viewPersonal.layer.shadowOffset = CGSize.zero
        viewPersonal.layer.shadowRadius = 5
        viewPersonal.layer.cornerRadius = 5
        businessswitch.setOn(false, animated: true)
        personalswitch.setOn(true, animated: true)
        //self.vw.frame = CGRect(x: self.vw.frame.origin.x, y: self.vw.frame.origin.y, width: self.vw.frame.size.width, height: self.viewBus.frame.size.height+self.viewBus.frame.origin.y+20)
        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.vw.frame.size.height + self.vw.frame.origin.y + 10)
        
        if (UserDefaults.standard.value(forKey: "profilevalue") != nil){
            businessswitch.setOn(false, animated: true)
            personalswitch.setOn(true, animated: true)
        }
        else{
            businessswitch.setOn(true, animated: true)
            personalswitch.setOn(false, animated: true)
        }
      
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       self.getprofile()
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
      
       
    }
    @objc func perswitch(_sender: UISwitch){
        if personalswitch.isOn{
           businessswitch.setOn(false, animated: true)
            UserDefaults.standard.set("profilevalue", forKey: "profilevalue")
            UserDefaults.standard.synchronize()
        }
        else{
         businessswitch.setOn(true, animated: true)
            UserDefaults.standard.removeObject(forKey: "profilevalue")
        }
    }
    @objc func busswitch(_sender: UISwitch){
        if businessswitch.isOn{
            personalswitch.setOn(false, animated: true)
              UserDefaults.standard.removeObject(forKey: "profilevalue")
        }
        else{
            personalswitch.setOn(true, animated: true)
               UserDefaults.standard.set("profilevalue", forKey: "profilevalue")
                          UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func btnPerprofile(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditpersonalController") as! EditpersonalController
        vc.diffstr = "1"
        vc.personaldet = personaldet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddpersonal(_ sender: CustomButton) {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditpersonalController") as! EditpersonalController
        vc.diffstr = "2"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddbusiness(_ sender: CustomButton) {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditbusinessController") as! EditbusinessController
        vc.diffstr = "2"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBusinessprofile(_ sender: UIButton) {
        self.view.endEditing(true)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditbusinessController") as! EditbusinessController
        vc.diffstr = "1"
        vc.businessdet = businessdet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getprofile(){
        
        SVProgressHUD.show()
       
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
                         self.personaldet = ary.value(forKey: "personal_profile") as! NSDictionary
                        
                        
                        self.imgPerprofile.layer.masksToBounds =
                        true
                         self.imgBusprofile.layer.masksToBounds = true
                        self.imgPerprofile.layer.cornerRadius = self.imgPerprofile.frame.size.height/2
                        self.imgBusprofile.layer.cornerRadius = self.imgBusprofile.frame.size.height/2
                       
                        
                        if(self.personaldet.count == 0){
                            self.viewPersonal.isHidden = true
                            self.btnAddpersonal.isHidden = false
                            self.btnPerprofile.isHidden = true
 
                        }else{
                            
                            self.lblPername.text = (self.personaldet.value(forKey:"name") as! String) + (self.personaldet.value(forKey:"lname") as! String)
                            self.lblPermobile.text = (self.personaldet.value(forKey:"mobile") as! String)
                            
                            self.lblPeremail.text = (self.personaldet.value(forKey:"email") as! String)
                            self.lblPerface.text = String((self.personaldet.value(forKey:"facebook") as! String))
                            self.lblPertwitter.text = String((self.personaldet.value(forKey:"twitter") as! String))
                            
                            if let profilepic = self.personaldet["profile_pic"] as? String {
                                let img = PIMAGE + profilepic
                                
                                self.imgPerprofile.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "userIcon.png"))
                            }
                            else if (self.personaldet["profile_pic"] as? NSNull) != nil {
                                
                                self.imgPerprofile.image = UIImage(named: "userIcon.png")
                            }
                            
                            self.viewPersonal.isHidden = false
                            self.btnAddpersonal.isHidden = true
                            self.btnPerprofile.isHidden = false
                            

                        }
                        
            
                        
                        if(self.businessdet.count == 0){
                            self.viewBusiness.isHidden = true
                            self.btnAddbusiness.isHidden = false
                            self.btnBusinessprofile.isHidden = true
                            
                        }else{
                            self.lblBusname.text = (self.businessdet.value(forKey:"company_name") as! String)
                            self.lblBusaddress.text = (self.businessdet.value(forKey:"address") as! String)
                            self.lblBusmobile.text = (self.businessdet.value(forKey:"company_mobile") as! String)
                            
                            self.lblBusemail.text = (self.businessdet.value(forKey:"company_email") as! String)

                            self.lblBusweb.text = (self.businessdet.value(forKey:"company_site") as! String)

                            if let profilepic = self.businessdet["company_logo"] as? String {
                                self.imgBusprofile.sd_setImage(with: URL(string:PIMAGE + (profilepic)), placeholderImage: UIImage(named: "userIcon.png"))
                            }
                            else if (self.businessdet["company_logo"] as? NSNull) != nil {
                                
                                self.imgBusprofile.image = UIImage(named: "userIcon.png")
                            }
                            self.viewBusiness.isHidden = false
                            self.btnAddbusiness.isHidden = true
                            self.btnBusinessprofile.isHidden = false
                            
                           
                        }
//                      self.vw.frame = CGRect(x: self.vw.frame.origin.x, y: self.vw.frame.origin.y, width: self.vw.frame.size.width, height: self.viewBus.frame.size.height+self.viewBus.frame.origin.y+20)
//                        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.vw.frame.size.height + self.vw.frame.origin.y + 10)
                        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

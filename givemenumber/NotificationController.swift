//
//  NotificationController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 07/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NotificationController: UIViewController {
    
    @IBOutlet weak var  btnBack: UIButton!
    @IBOutlet weak var viewNotify: UIView!
    @IBOutlet weak var ViewProfile: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var switchnotifi: UISwitch!
    @IBOutlet weak var switchTakemy: UISwitch!
    @IBOutlet weak var switchGimme: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblMiles: UILabel!
    var notifystr = ""
    var takestr = ""
    var givestr = ""
    var radiusstr = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getsettings()

        // Do any additional setup after loading the view.
    }
    
    func getsettings(){
        
        SVProgressHUD.show()
        Alamofire.request(
            URL_Settings ,
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
                        let settingsary = ary.value(forKey: "settings") as! NSDictionary
                        self.givestr = settingsary.value(forKey: "give_status") as! String
                        self.takestr = settingsary.value(forKey: "take_status") as! String
                        self.notifystr = settingsary.value(forKey: "isnotify") as! String
                        self.radiusstr = settingsary.value(forKey: "radius") as! String
                        
                        self.lblMiles.text = "\(self.radiusstr) Miles."
                        self.slider.value = Float(self.radiusstr) as! Float

                        if(self.givestr == "1"){
                            self.switchGimme.setOn(true, animated: true)
                            self.switchGimme.thumbTintColor  = UIColor.white
                        }else{
                            self.switchGimme.setOn(false, animated: true)
                            self.switchGimme.thumbTintColor  = UIColor(red:58/255, green:131/255, blue:254/255, alpha: 1)
                        }
                        
                        if(self.takestr == "1"){
                            self.switchTakemy.setOn(true, animated: true)
                            self.switchTakemy.thumbTintColor  = UIColor.white
                        }else{
                            self.switchTakemy.setOn(false, animated: true)
                            self.switchTakemy.thumbTintColor  = UIColor(red:58/255, green:131/255, blue:254/255, alpha: 1)
                        }
                        
                        if(self.notifystr == "1"){
                            self.switchnotifi.setOn(true, animated: true)
                            self.switchnotifi.thumbTintColor  = UIColor.white
                        }else{
                            self.switchnotifi.setOn(false, animated: true)
                            self.switchnotifi.thumbTintColor  = UIColor(red:58/255, green:131/255, blue:254/255, alpha: 1)
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
    @IBAction func btnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
//        let  navController = self.tabBarController?.viewControllers![3] as! UINavigationController
//        let secondViewController = navController.viewControllers[0] as! SettingsController
//        tabBarController!.selectedIndex = 3
    }
    @IBAction func Sliderchanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        print("Slider changing to \(currentValue) ?")
        lblMiles.text = "\(currentValue) Miles."
        radiusstr = String(currentValue)
    }
   
    @IBAction func switchNotify(mySwitch: UISwitch) {
        if mySwitch.isOn {
            switchnotifi.thumbTintColor  = UIColor.white
            self.notifystr = "1"
          
        } else {
            switchnotifi.thumbTintColor  = UIColor(red:58/255, green:131/255, blue:254/255, alpha: 1)
            self.notifystr = "0"
        }
        
       
    }
    
  
    
    @IBAction func switchGimme(mySwitch: UISwitch) {
        if mySwitch.isOn {
            switchGimme.thumbTintColor  = UIColor.white
              self.givestr = "1"
            
        } else {
            switchGimme.thumbTintColor  = UIColor(red:58/255, green:131/255, blue:254/255, alpha: 1)
              self.givestr = "0"
        }
        
    }
    
    @IBAction func switchTakemy(mySwitch: UISwitch) {
        if mySwitch.isOn {
            switchTakemy.thumbTintColor  = UIColor.white
              self.takestr = "1"
            
        } else {
            switchTakemy.thumbTintColor  = UIColor(red:58/255, green:131/255, blue:254/255, alpha: 1)
              self.takestr = "0"
            
        }
        
    }
    
    @IBAction func btnSave(_ sender: CustomButton) {
        self.updatesetting()
    }
    func updatesetting(){
    
        
        var Parameters = [String: String]()
        Parameters["take_status"] = self.takestr
        Parameters["give_status"] = self.givestr
        Parameters["radius"] = self.radiusstr
        Parameters["isnotify"] = self.notifystr
        
        var url = ""
        url = URL_Settings + "/" + (UserDefaults.standard.value(forKey: "userid") as! String)
        
        
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

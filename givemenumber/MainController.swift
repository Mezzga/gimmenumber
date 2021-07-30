//
//  MainController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 09/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Koloda
import Alamofire
import SVProgressHUD
import SDWebImage
import CoreLocation

class MainController: UIViewController,KolodaViewDelegate,KolodaViewDataSource,CLLocationManagerDelegate {
    @IBOutlet weak var switchbtn: UISwitch!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var viewTinder: UIView!
    @IBOutlet weak var lblTindername:UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnNotlike: UIButton!
    @IBOutlet weak var btnTake: UIButton!
    @IBOutlet weak var btnGiveme: UIButton!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewSubfilter: UIView!
    @IBOutlet weak var btnFiltpersonal: UIButton!
    @IBOutlet weak var btnFiltBusiness: UIButton!
    @IBOutlet weak var imgFiltpersonal: UIImageView!
    @IBOutlet weak var imgFiltbusiness: UIImageView!
    @IBOutlet weak var btnFiltcancel: CustomButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var vw: UIView!
    
    var manager : CLLocationManager!
   var isprivate : String!
    var sent_roleid : String!
    var type = ""
    var ftype = ""
    var rid = ""
    var status = ""
    var lat = ""
    var lng = ""
    var isLocationUpdated = false

    var userdet:NSMutableArray = []
    let imgary = ["userIcon.png","userIcon.png","userIcon.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
   

        btnTake.layer.cornerRadius = 20
        btnGiveme.layer.cornerRadius = 20
        
        viewSubfilter.layer.shadowColor = UIColor.lightGray.cgColor
        viewSubfilter.layer.shadowOpacity = 1
        viewSubfilter.layer.shadowOffset = CGSize.zero
        viewSubfilter.layer.shadowRadius = 5
        viewSubfilter.layer.cornerRadius = 5
        
        
        kolodaView.layer.shadowColor = UIColor.lightGray.cgColor
        kolodaView.layer.shadowOpacity = 1
        kolodaView.layer.shadowOffset = CGSize.zero
        kolodaView.layer.shadowRadius = 5
        kolodaView.layer.cornerRadius = 5
        
        viewFilter.isHidden = true
       imgFiltbusiness.image = UIImage(named: "")
       imgFiltpersonal.image = UIImage(named: "ic_tick.png")
        UserDefaults.standard.set("personalclick", forKey: "personalclick")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendrequestuser), name: NSNotification.Name(rawValue: "sendrequestuser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendrequestcontact), name: NSNotification.Name(rawValue: "sendrequestcontact"), object: nil)

        switchbtn.addTarget(self, action: #selector(switchfun(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
   
    override func viewDidAppear(_ animated: Bool) {
             self.getsettings()
    }
    
    @objc func switchfun(_ sender: UISwitch) {
     
        
        if switchbtn.isOn {
           isprivate = "0"
        }
        else{
            isprivate = "1"
        }
        print(isprivate)
        
                   var Parameters = [String: String]()
                   Parameters["isprivate"] = isprivate
                   
                   
        let urlstr = URL_Getsettings + (UserDefaults.standard.value(forKey: "userid") as! String)
            print(Parameters)
        print("urlstr:",urlstr)
                   Alamofire.request(
                       urlstr,
                       method: .put,
                       parameters: Parameters,
                        encoding: JSONEncoding(options: []),
                       headers: [
                       "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                       "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String),
                        "Content-Type":"application/x-www-form-urlencoded"]
                       )
                       .validate()
                       .responseJSON { (response) -> Void in
                          
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
       

        tabBarController!.selectedIndex = 0
        btnTake.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
        btnTake.setTitleColor(UIColor.white, for: .normal)
        
        btnGiveme.backgroundColor = UIColor.white
        btnGiveme.setTitleColor(UIColor.black, for: .normal)
        isLocationUpdated = false
        self.makeservice()
       
    }
    
    @objc func sendrequestuser(_ notification: Notification) {
        print(notification.userInfo as! [String: Any])
        let usercount = UserDefaults.standard.integer(forKey: "usercount")
        if(usercount > 0){
            self.tabBarController?.tabBar.items?[1].badgeValue = String(usercount)
            
        }else{
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
            
        }
        let dic = notification.userInfo as! [String: Any]
        let  navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let secondViewController = navController.viewControllers[0] as! UserlistController
        secondViewController.type = dic["type"] as! String
        tabBarController!.selectedIndex = 1
        
        //        print(notification.userInfo as! [String: Any])
        //        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //        if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "UserlistController") as? UserlistController,
        //            let tabBarVC = self.window?.rootViewController as? UITabBarController{
        //            tabBarVC.selectedViewController!.present(conversationVC, animated: true, completion: nil)
        //        }
        
    }
    @objc func sendrequestcontact(_ notification: Notification) {
        print(notification.userInfo as! [String: Any])
        let contactcount = UserDefaults.standard.integer(forKey: "contactcount")
        if(contactcount > 0){
            self.tabBarController?.tabBar.items?[2].badgeValue = String(contactcount)
            
        }else{
            self.tabBarController?.tabBar.items?[2].badgeValue = nil
        }
        let dic = notification.userInfo as! [String: Any]
        let  navController = self.tabBarController?.viewControllers![2] as! UINavigationController
        let secondViewController = navController.viewControllers[0] as! ContactslistController
        secondViewController.type = dic["type"] as! String
        tabBarController!.selectedIndex = 2
        
    }
    func makeservice() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }else{
            
            manager.requestWhenInUseAuthorization()
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  let userLocation:CLLocation = locations[0] as CLLocation
        
        
        let currentLocation = locations.last!
        
        if (!isLocationUpdated)
        {
            isLocationUpdated = true
            lat = String(currentLocation.coordinate.latitude)
            lng = String(currentLocation.coordinate.longitude)
            
            UserDefaults.standard.set(lat, forKey: "lat")
            UserDefaults.standard.set(lng, forKey: "lng")
            UserDefaults.standard.synchronize()
            
            self.updategcm()
            self.userdet = NSMutableArray()
            self.type = "1"
            self.ftype = "3"
            self.kolodaView.reloadData()
            self.getusers()
        }
        //  if(((UserDefaults.standard.value(forKey: "roleid")) as! String == "2") || ((UserDefaults.standard.value(forKey: "roleid")) as! String == "1")){
       
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
                          let givestr = settingsary.value(forKey: "give_status") as! String
                           let takestr = settingsary.value(forKey: "take_status") as! String
                         
                           if givestr == "1" && takestr == "1"{
                            self.switchbtn.setOn(false, animated: true)
                                                       self.isprivate = "0"
                         
                           }else{
                            
                            self.switchbtn.setOn(true, animated: true)
                               self.isprivate = "1"
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
    func updategcm(){
       
            var Parameters = [String: String]()
            Parameters["gcm_id"] = UserDefaults.standard.value(forKey: "devicetoken") as? String
            Parameters["lat"] = lat
            Parameters["lng"] = lng
            Parameters["device"] = "I"
            print(Parameters)
            Alamofire.request(
                URL_Updatedgcm ,
                method: .post,
                parameters: Parameters,
                encoding: JSONEncoding(options: []),
                headers: [
                    "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                    "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String)]
                )
                .validate()
                .responseJSON { (response) -> Void in
                    if response.result.isSuccess {
                        
                        let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(ary)
                        
                        let success = ary.value(forKey: "status") as! NSDictionary
                        let code = success.value(forKey: "code") as! NSNumber
                        
                        if(code == 1000){
                            
                           

                        }else{
                            
                            self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                        }
                    }
                        
                        
                    else {
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

    @IBAction func btnFilter(_ sender: Any) {
        viewFilter.isHidden = false
    }
    
    @IBAction func btnTake(_ sender: UIButton) {
        btnTake.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
        btnTake.setTitleColor(UIColor.white, for: .normal)
        
        btnGiveme.backgroundColor = UIColor.white
        btnGiveme.setTitleColor(UIColor.black, for: .normal)
        userdet = NSMutableArray()
        type = "1"
        kolodaView.reloadData()

        self.getusers()
    }
    
    @IBAction func btnGiveme(_ sender: UIButton) {
        btnGiveme.backgroundColor = UIColor(red: 35/255.0, green: 90/255.0, blue: 161/255.0, alpha: 1.0)
        btnGiveme.setTitleColor(UIColor.white, for: .normal)
        
        btnTake.backgroundColor = UIColor.white
        btnTake.setTitleColor(UIColor.black, for: .normal)
        userdet = NSMutableArray()
        type = "2"
        kolodaView.reloadData()

        self.getusers()
    }
    
    @IBAction func btnNotlike(_ sender: UIButton) {
        
        if(userdet.count >= sender.tag+2){
            kolodaView.isHidden = false
            
        }else{
             kolodaView.isHidden = true
        }
       
        kolodaView?.swipe(.left)
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        if(userdet.count >= sender.tag+2){
            kolodaView.isHidden = false
            
        }else{
            kolodaView.isHidden = true
        }
         kolodaView?.swipe(.right)
    }
    
    @IBAction func btnFiltpersonal(_ sender: Any) {
        
         kolodaView.reloadData()
        imgFiltbusiness.image = UIImage(named: "")
        imgFiltpersonal.image = UIImage(named: "ic_tick.png")
        UserDefaults.standard.set("personalclick", forKey: "personalclick")
        UserDefaults.standard.synchronize()
        viewFilter.isHidden = true
        userdet = NSMutableArray()
        kolodaView.reloadData()

        ftype = "3"
        self.getusers()
    }
    
    @IBAction func btnFiltbusiness(_ sender: Any) {
         kolodaView.reloadData()
        imgFiltpersonal.image = UIImage(named: "")
        imgFiltbusiness.image = UIImage(named: "ic_tick.png")
        UserDefaults.standard.removeObject(forKey: "personalclick")
        viewFilter.isHidden = true
        userdet = NSMutableArray()
        kolodaView.reloadData()

        ftype = "2"
        self.getusers()
        
    }
    
    @IBAction func btnFiltcancel(_ sender: CustomButton) {
        viewFilter.isHidden = true
    }
    
    
    func getusers(){
    print(UserDefaults.standard.value(forKey: "apikey") as! String)
    print(UserDefaults.standard.value(forKey: "userid") as! String)
    SVProgressHUD.show()
    var Parameters = [String: Any]()
    Parameters["type"] = self.type
    Parameters["page"] = 0
    Parameters["ftype"] = self.ftype
    Parameters["mile"] = 30
    Parameters["fromlat"] = lat
    Parameters["fromlng"] = lng
    Parameters["limit"] = 10
        if (UserDefaults.standard.value(forKey: "personalclick") != nil) {
              Parameters["roleid"] = "3"
        }
        else{
             Parameters["roleid"] = "2"
        }

    print(Parameters)
    Alamofire.request(
        URL_Users ,
        method: .post,
        parameters: Parameters,
        encoding: JSONEncoding(options: []),
        headers: [
            "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
            "apikey":(UserDefaults.standard.value(forKey: "apikey") as! String)]
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
                    //    self.kolodaView.reloadData()


                    }
        //            print(self.userdet)
                    if(self.userdet.count>0){
//                        self.kolodaView.addSubview(self.viewTinder)
                        self.kolodaView.isHidden = false
                        self.kolodaView.dataSource = self
                        self.kolodaView.delegate = self
                        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal


                    }else{
                        self.kolodaView.isHidden = true
                    }
                    

                }else{

                    self.view.makeToast((success.value(forKey: "message") as! String), duration: 3.0, position: .bottom)
                }
            }


            else {
              
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

    //    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    //        let position = kolodaView.currentCardIndex
    //        for i in 1...4 {
    //            dataSource.append(UIImage(named: "Card_like_\(i)")!)
    //        }
    //        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    //    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
   //     UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let dic = (userdet[index] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        rid = (dic["uid"] as! String)
        print(index+2)
        
        if(index+2 <= userdet.count){
            kolodaView.isHidden = false
            
        }else{
            kolodaView.isHidden = true
        }

        if direction == SwipeResultDirection.left{
            
            status = "2"
            self.swipeapi()
            
        }else if direction == SwipeResultDirection.right{
            
            status = "0"
            self.swipeapi()
        }
    }

// MARK: KolodaViewDataSource

    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return userdet.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
    kolodaView.backgroundColor = UIColor.clear
        let dic = (userdet[index] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        lblTindername.text = (dic["name"] as! String)
        rid = (dic["uid"] as! String)
        let vw = UIView()
        vw.frame = koloda.frame;
        vw.layer.cornerRadius = 10
        let img = UIImageView()
        img.frame = CGRect(x:0 , y: 0, width: koloda.frame.size.width, height: koloda.frame.size.height-80)
        //   img.contentMode = .scaleAspectFit
        if let profilepic = dic["profile_pic"] as? String {
            let imgstr = PIMAGE + profilepic
            img.sd_setImage(with: URL(string: imgstr), placeholderImage: UIImage(named: "ic_avatar_home.png"))
        }
        else if (dic["profile_pic"] as? NSNull) != nil {
            img.image = UIImage(named: "ic_avatar_home.png")
        }
        vw.addSubview(img)
         let vwlbl = UIView()
         vwlbl.frame = CGRect(x:0 , y: koloda.frame.size.height - 80, width: koloda.frame.size.width, height: 80)
        let lbl = UILabel()
        lbl.frame = CGRect(x:10 , y: 0, width: koloda.frame.size.width - 20, height: 80)
        lbl.text = (dic["name"] as! String)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.white
        vwlbl.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        vwlbl.layer.cornerRadius = 8
        vwlbl.addSubview(lbl)
        vw.addSubview(vwlbl)
        //    return UIImageView(image: UIImage(named: imgary[index]))
        return vw
    }
    
    func swipeapi(){
       
        if isprivate == "1" {
            if (UserDefaults.standard.value(forKey: "profilevalue") != nil) {
                sent_roleid = "2"
            }
            else{
                 sent_roleid = "3"
            }
        }
        else{
            sent_roleid = UserDefaults.standard.value(forKey: "roleid") as? String
        }
        
        var Parameters = [String: Any]()
        Parameters["rid"] = rid
        Parameters["type"] = type
        Parameters["roleid"] = ftype
        Parameters["status"] = status
        Parameters["sent_roleid"] = sent_roleid
        print(Parameters)
        Alamofire.request(
            URL_Request ,
            method: .post,
            parameters: Parameters,
            encoding: JSONEncoding(options: []),
            headers: [
                "userid": (UserDefaults.standard.value(forKey: "userid") as! String),
                "apikey": (UserDefaults.standard.value(forKey: "apikey") as! String)]
            )
            .validate()
            .responseJSON { (response) -> Void in
                if response.result.isSuccess {
                    
                    let ary =  (response.result.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(ary)
                    
                    let success = ary.value(forKey: "status") as! NSDictionary
                    let code = success.value(forKey: "code") as! NSNumber
                    
                    if(code == 1000){
                        
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

    
    //    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //        return Bundle.main.loadNibNamed("OverlayView", owner: self, options:  nil)?[0] as? OverlayView
    //    }
}

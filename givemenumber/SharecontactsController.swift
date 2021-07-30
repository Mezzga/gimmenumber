//
//  SharecontactsController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 11/10/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit
import Koloda
import Alamofire
import SVProgressHUD
import SDWebImage
import CoreLocation

class SharecontactsController: UIViewController,KolodaViewDelegate,KolodaViewDataSource,CLLocationManagerDelegate {

    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var viewTinder: UIView!
    @IBOutlet weak var lblTindername:UILabel!

    
    @IBOutlet weak var vw: UIView!
    
    var manager : CLLocationManager!
    
    var generalstr : String!
    var type = ""
    var ftype = ""
    var rid = ""
    var status = ""
    var lat = ""
    var lng = ""
    var shareid = ""
    var isLocationUpdated = false
    
    var userdet:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = "1"
        ftype = ""
        lat = UserDefaults.standard.value(forKey: "lat") as! String
        lng = UserDefaults.standard.value(forKey: "lng") as! String
        self.getusers()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func getusers(){
        print(UserDefaults.standard.value(forKey: "apikey") as! String)
        print(UserDefaults.standard.value(forKey: "userid") as! String)
        SVProgressHUD.show()
        var Parameters = [String: Any]()
        Parameters["type"] = type
        Parameters["page"] = 0
        Parameters["ftype"] = self.ftype
        Parameters["mile"] = 30
        Parameters["fromlat"] = lat
        Parameters["fromlng"] = lng
        Parameters["limit"] = 10
        
        
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
  //          self.swipeapi()
            
        }else if direction == SwipeResultDirection.right{
            
            status = "0"
            self.view.endEditing(true)
            
            if generalstr == "1" {
                 self.swipeapi()
            }
            else {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "PickcontactsController") as! PickcontactsController
                vc.receiverid = rid
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
           
     //       self.swipeapi()
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
        
        var Parameters = [String: Any]()
        Parameters["shareid"] = shareid
        Parameters["receiverid"] = rid
        Parameters["type"] = "4"
        Parameters["status"] = status
        print("Parameters:",Parameters)
        print("userid:",(UserDefaults.standard.value(forKey: "userid") as! String))
        print("apikey:",(UserDefaults.standard.value(forKey: "apikey") as! String))
        Alamofire.request(
            URL_ShareoUcontact ,
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

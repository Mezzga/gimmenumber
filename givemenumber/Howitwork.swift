//
//  Howitwork.swift
//  givemenumber
//
//  Created by BlueGenie on 20/03/20.
//  Copyright © 2020 BGMacMIni2. All rights reserved.
//

import UIKit

class Howitwork: UIViewController,UITableViewDelegate,UITableViewDataSource {
@IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnok: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet var table: UITableView!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var contlbl: UILabel!
    @IBOutlet var content: UITextView!
      var titlearr:[String] = []
    var imgarr:[String] = []
      var contentarr:[String] = []
    var contentstr : String!
    var flag : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnok.layer.cornerRadius = 6
        btnok.isHidden = true
        flag = true
titlearr  = ["Profile","Share","Address Book","Emergency"]
        imgarr = ["cprofile.png","share.png","book.png","emer.png"]
 contentarr = ["Create your profile, fill in your name, number, email with other optional info and you're done","Exchange your info without having to type on a keyboard The app takes care of everything for you in one click","Thanks to this new app, you will be able to directly save the coordinates in your address book which can then be shared with a third person or synchronized with another phone","Your address book remains accessible even when your phone is off Just sign in to your account from any other medium, GSM or tablet."]
    contentstr = "To use the above features in our app, Please provide permission to access your 'phone contacts'. We will upload and save it on our secure server. So that you can access it from anywhere using our app."
        table.isScrollEnabled = false
        table.frame = CGRect(x: table.frame.origin.x, y: table.frame.origin.y, width: table.frame.size.width, height: CGFloat(titlearr.count * 86))
        contlbl.text = contentstr
          contlbl.frame = CGRect(x: contlbl.frame.origin.x, y: table.frame.origin.y + table.frame.size.height, width: contlbl.frame.size.width, height:contlbl.frame.size.height )
      checkbox.addTarget(self, action: #selector(checkbox(_:)), for: .touchUpInside)
        btnback.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        btnok.addTarget(self, action: #selector(btnok(_:)), for: .touchUpInside)
        let attributedString = NSMutableAttributedString(string: "I have read and agree with above points and Privacy Policy")
               let linkRange = (attributedString.string as NSString).range(of: "Privacy Policy")
               attributedString.addAttribute(NSAttributedString.Key.link, value: "http://geniefinserv.in/gimme/privacy_policy.html", range: linkRange)
               
               
               
               attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: linkRange)
        content.isScrollEnabled = false
               content.attributedText = attributedString
               content.textAlignment = NSTextAlignment.left
               content.textColor = UIColor.black
        checkbox.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
        // Do any additional setup after loading the view.
    }
    @objc func checkbox(_ sender: UIButton){
        if flag == true {
             checkbox.setImage(UIImage.init(named: "check.png"), for: .normal)
              btnok.isHidden = false
            flag = false
        }
        else {
             checkbox.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
              btnok.isHidden = true
            flag = true
        }
    }

    @objc func back(_ sender: UIButton) {
        
     self.navigationController?.popViewController(animated: true)
    }
    @objc func btnok(_ sender: UIButton){
        
        let alert = UIAlertController(title: "Users Agreement", message: "Dear users We are letting you know that when chose the option of copy and save or just save in gimme your number app you are also creating a virtual phone book account that will be hosted in our server.\n\nDo you agree?", preferredStyle: .alert)

       alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Yay! You brought your towel!")
        UserDefaults.standard.set("terms", forKey: "terms")
               UserDefaults.standard.synchronize()
               
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                             appDelegate.login()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return titlearr.count
        
    }
//    @IBOutlet weak var vw: UIView!
//    @IBOutlet weak var lbltitle: UILabel!
//    @IBOutlet weak var lblcontent: UILabel!
//    @IBOutlet weak var img: UIImageView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        let cell:HowCell
            = tableView.dequeueReusableCell(withIdentifier: "HowCell") as! HowCell
        
        cell.vw.layer.cornerRadius = cell.vw.frame.height/2
        
        cell.img.image = UIImage(named: imgarr[indexPath.row] )
        cell.lbltitle.text = titlearr[indexPath.row]

        cell.lblcontent.text = contentarr[indexPath.row]
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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

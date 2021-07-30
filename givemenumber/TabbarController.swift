//
//  TabbarController.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 27/09/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) {
        // Your code here
        if(tabBarController.selectedIndex == 1){
            print("dhdjkgjd")
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

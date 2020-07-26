//
//  GameTabViewController.swift
//  set4
//
//  Created by Isaac on 7/26/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class GameTabViewController: UITabBarController, UITabBarControllerDelegate {

    //override var delegate: UITabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    

//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let svc = viewController as? SetViewController
//        {
//           // svc.shouldReset = true
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        print("I am here")
//        print(segue.destination)
//        print(segue.identifier)
//        if let svc = segue.destination as? SetViewController
//        {
//            svc.shouldReset = true
//            print("shouldReset")
//        }
        
    }
    */

}

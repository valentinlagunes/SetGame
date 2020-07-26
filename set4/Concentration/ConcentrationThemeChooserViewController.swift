//
//  ConcentrationThemeChooserViewController.swift
//  set4
//
//  Created by Isaac on 7/25/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    // MARK: - Navigation
    let themes = [
        "Flags": "🇺🇸🇲🇽🇦🇺🇩🇪🇨🇦🇯🇲🇩🇰🇵🇱🇨🇴",
        "Animals": "🐶🦜🦈🐘🐼🐉🐥🦄🦖",
        "Food": "🍉🍆🍑🍒🍗🥑🍟🌭🥚",
        "Halloween": "🦇😱🙀😈🎃👻🍭🍬🍎",
        "Clothes": "🦺🥋👘👙👔👗👡🩱👚",
        "Plants": "🍄🌻🎄🌹🌵🌴🍀🍁🌸"
        
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
//    @IBAction func ChangeTheme(_ sender: Any) {
//        if let cvc = splitViewDetailConcentrationViewController {
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
//                cvc.theme = theme
//                lastSeguedToConcentrationViewController = cvc
//            }
//        }
//        else if let cvc = lastSeguedToConcentrationViewController {
//            navigationController?.pushViewController(cvc, animated: true)
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
//            cvc.theme = theme
//            }
//        }
//        else
//        {
//            performSegue(withIdentifier: "Choose Theme", sender: sender)
//        }
//    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
                cvc.currentTheme = themeName
                lastSeguedToConcentrationViewController = cvc
                //print(cvc.currentTheme)
            }
        }
        else if let cvc = lastSeguedToConcentrationViewController {
            navigationController?.pushViewController(cvc, animated: true)
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
                cvc.currentTheme = themeName
               //print(cvc.currentTheme)
            }
        }
        else
        {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton
            {
                if let themeName = button.currentTitle {
                    if let theme = themes[themeName] {
                        if let cvc = segue.destination as? ConcentrationViewController {
                            cvc.theme = theme
                            cvc.currentTheme = themeName
                            //print(cvc.currentTheme)
                            lastSeguedToConcentrationViewController = cvc
                        }
                    }
                }
            }
        }
    }
    

}


//
//  FR_NavViewController.swift
//  furongbook
//
//  Created by wlx on 2020/11/16.
//

import UIKit

public class FR_NavViewController: KLTNavigationController {
    
    public override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    public override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.mainTHemeColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
}

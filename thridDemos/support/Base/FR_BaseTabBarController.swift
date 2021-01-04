//
//  FR_BaseTabBarController.swift
//  WLXUtils
//
//  Created by wlx on 2020/12/21.
//

import UIKit


public struct FR_TabbarItemModel {
    public var title: String
    public var normalImage: String
    public var selectedImage: String
    public var viewController: FR_BaseViewController
    
    public init(title: String, normalImage: String, selectedImage: String, viewController: FR_BaseViewController){
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.viewController = viewController
    }
}

open class FR_BaseTabBarController: UITabBarController {
    
    /// 选中时的颜色
    public var tintColor: UIColor? {
        willSet {
            self.tabBar.tintColor = newValue
        }
    }
    
    /// tabbar的Item配置
    public var tabBarItemModels: Array<FR_TabbarItemModel>? {
        willSet {
            guard let items = newValue else {
                fatalError("tabbar的item不能为空")
            }
            
            var vcs:[UIViewController] = []
            for item in items {
                let vc = setTabBarVC(item: item)
                vcs.append(vc)
            }
            self.viewControllers = vcs
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.isTranslucent = false
//        tabBar.shadowImage = UIImage()
//        tabBar.backgroundImage = UIImage()
//        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
//        tabBar.layer.shadowOpacity = 0.2
//        tabBar.layer.shadowOffset = CGSize.init(width: 0, height: -3)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setTabBarVC(item: FR_TabbarItemModel) -> FR_NavViewController {
        let nav = FR_NavViewController(rootViewController: item.viewController)
        nav.tabBarItem.title = item.title
        nav.tabBarItem.image = UIImage.image(item.normalImage).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        nav.tabBarItem.selectedImage = UIImage.image(item.selectedImage).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return nav
    }
}

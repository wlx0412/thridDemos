//
//  HomeViewController.swift
//  thridDemos
//
//  Created by wlx on 2021/1/4.
//

import UIKit


class HomeViewController: FR_BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you w ill often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = UIViewController()
        let vc = TestViewController()
        vc.view.backgroundColor = UIColor.randomColor()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

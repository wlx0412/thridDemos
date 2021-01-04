//
//  TestViewController.swift
//  thridDemos
//
//  Created by wlx on 2021/1/4.
//

import UIKit

class TestViewController: FR_BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.randomColor()
//        canGoBack = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func setupUI() {
        title = "test"
    }
    
    override func goBackBlock() {
        let alertVC = SystemTool.alertVC(title: "xxx", message: "xxx", btns: ["确定"], cancel: true) { [weak self](index) in
            self?.canGoBack = true
            self?.navigationController?.popViewController(animated: true)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}

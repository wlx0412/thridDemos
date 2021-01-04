//
//  FR_TableViewController.swift
//  thridDemos
//
//  Created by wlx on 2021/1/4.
//

import UIKit

class FR_TableViewController: FR_BaseViewController {
    
    //tableView
    lazy var tableView:UITableView = {
        let tab = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)

        self.scrollView = tab
        tab.ep.set(emptyView: emptyView)
        return tab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

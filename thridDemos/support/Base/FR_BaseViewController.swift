//
//  FR_BaseViewController.swift
//  furongbook
//
//  Created by wlx on 2020/11/17.
//

import UIKit



open class FR_BaseViewController: UIViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public var canGoBack = true
    
    //滚动视图
    var scrollView: UIScrollView?
    var allowRefresh: Bool? = true //下拉刷新
    var allowLoad: Bool? = true//上拉加载
    var page: Int = 1 //页码
    var models: Array<Any>?
    var pullType = PullType.refresh
    
    
    //空白视图
    let emptyView: EmptyPageView = EmptyPageView.Template.standard
    .config(button: { (item) in
        item.setTitleColor(.white, for: UIControl.State.normal)
        item.backgroundColor = UIColor.mainTHemeColor
    })
    .mix()
    

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    open func setupUI() {
        //背景颜色
        view.backgroundColor = UIColor.backgroundColor()
        //去掉返回按钮文字
        let item = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    open func getData() {
        
    }
    
    //设置导航栏右侧
    @discardableResult
    open func setNavRight(title: String, imgStr: String? = nil, titleColor: UIColor?, font: UIFont?,_ action: @escaping (UIButton)->()) -> UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        btn.setTitle(title, for: UIControl.State.normal)
        btn.titleLabel?.font = font ?? UIFont.font14
        btn.contentHorizontalAlignment = .right
        if let str = imgStr {
            btn.setImage(UIImage.image(str), for: UIControl.State.normal)
        }
        btn.setTitleColor(titleColor ?? UIColor.labelColor(), for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        btn.addTouchUpInSideBtnAction { (btn) in
            action(btn)
        }
        return btn
    }
    
    /// 是否能返回
    /// - Returns: Bool
    @objc open func goBack() -> Bool{
        if canGoBack {
            return true
        } else {
            goBackBlock()
            return false
        }
    }
    
    /// 点击返回按钮的回调
    /// - Returns: 无
    func goBackBlock() -> Void {
        
    }
    
    
    func createScrollView() {
        if self.scrollView == nil {
            scrollView = UIScrollView()
            self.view.addSubview(scrollView!)
            scrollView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
        
        if allowRefresh! {
            self.scrollView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        }
        if allowLoad! {
            self.scrollView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                self?.loadMore()
            })
        }
    }
    
    
    // MARK: --- 刷新
    @objc func refresh() {
        page = 1
        pullType = .refresh
        getData()
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime(integerLiteral: 2)) { [weak self] in
//            self?.scrollView?.mj_header?.endRefreshing()
//            self?.listCollectionView.mj_header?.endRefreshing()
//            self?.tableView.mj_header?.endRefreshing()
//        }
    }
    
    @objc func loadMore(){
        page += 1
        pullType = .loadMore
        getData()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime(integerLiteral: 2)) { [weak self] in
//            self?.scrollView?.mj_footer?.endRefreshing()
//            self?.listCollectionView.mj_footer?.endRefreshing()
//            self?.tableView.mj_footer?.endRefreshing()
//        }
    }
    
    //处理结果
    func loadOrRefresh(flag: Bool, tempArr: Array<Any>?) {
        if models == nil {
            models = []
        }
        
        switch pullType {
        case .refresh:
            models = tempArr
            
            if tempArr?.count == Constants.kPageSize {
                scrollView?.mj_footer?.endRefreshing()
            }else{
                scrollView?.mj_footer?.endRefreshingWithNoMoreData()
            }
        case .loadMore:
            if !flag {
                page -= 1
                scrollView?.mj_footer?.endRefreshing()
                return
            }
            
            if let arr = tempArr {
                if arr.count > 0 {
                    models?.append(contentsOf: arr)
                    
                    if arr.count == Constants.kPageSize {
                        scrollView?.mj_footer?.endRefreshing()
                    }else{
                        scrollView?.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    page -= 1
                    scrollView?.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        }
        
        if let tab = scrollView as? UITableView {
            tab.reloadData()
        } else if let collection = scrollView as? UICollectionView {
            collection.reloadData()
        }
    }
}

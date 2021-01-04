//
//  FR_CollectionViewController.swift
//  thridDemos
//
//  Created by wlx on 2021/1/4.
//

import UIKit

class FR_CollectionViewController: FR_BaseViewController {
    
    lazy var listCollectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        self.adapter.collectionView = collectionView
        
        self.scrollView = collectionView
        collectionView.ep.set(emptyView: emptyView)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var adapter = { () -> ListAdapter in
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        return adapter
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
        self.view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}

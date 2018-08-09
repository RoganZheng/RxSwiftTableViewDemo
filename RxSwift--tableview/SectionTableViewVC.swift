//
//  SectionTableViewVC.swift
//  RxSwift--tableview
//
//  Created by drogan Zheng on 2018/8/7.
//  Copyright © 2018年 RxSwift. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SectionTableViewVC: UIViewController {

    let disoposeBag = DisposeBag()
    var sectionTableView : UITableView!
    var sectionDatas = sectionData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "组tableView"
        createTableView()
        bindViewModel()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SectionTableViewVC{
    func createTableView() -> Void {
        self.view.backgroundColor = UIColor.lightGray
        sectionTableView = UITableView(frame: self.view.bounds, style: .plain)
        sectionTableView.register(normalTableViewCell.self, forCellReuseIdentifier: normalTableViewCell.description())
        self.view.addSubview(sectionTableView)

    }
    
    func bindViewModel() -> Void {
        let dataS = RxTableViewSectionedReloadDataSource<SectionModel<String,SectionDataModel>>(configureCell: { (dataSource, desTableView, indexPath, model) -> UITableViewCell in
            let cell = self.sectionTableView.dequeueReusableCell(withIdentifier: normalTableViewCell.description(), for: indexPath) as? normalTableViewCell
            cell?.firstLable?.text = model.firstName
            cell?.secondLable?.text = model.secondName
            
            return cell!
            
        }, titleForHeaderInSection: { (dataSource, index) -> String? in
            
            return dataSource.sectionModels[index].model
        })
        
        sectionDatas.sectionArr.asDriver(onErrorJustReturn: [])
            .drive(sectionTableView.rx.items(dataSource: dataS))
            .disposed(by: disoposeBag)
        
    }
    
}

//
//  TableViewViewController.swift
//  RxSwift--tableview
//
//  Created by drogan Zheng on 2018/8/4.
//  Copyright © 2018年 RxSwift. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewViewController: UIViewController {

    var firstTableView: UITableView!
    let resuerId:String = "normalCell"
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "normalTableView"
        createTableView()
        bindViewModel()
        RxTableViewEvent()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension TableViewViewController{
    func createTableView() -> Void {
            firstTableView = UITableView(frame: self.view.bounds, style: .plain)
            view.addSubview(firstTableView)
            //tableView行操作必须打开，才可移动cell
//            firstTableView.isEditing = true
            firstTableView.backgroundColor = UIColor.orange
            firstTableView.register(normalTableViewCell.self, forCellReuseIdentifier: resuerId)
        }
    
    func bindViewModel() -> Void {
            let items = Observable.just(FirstTableViewModel().arr)
            items.bind(to: self.firstTableView.rx.items){(tb,row,model) -> UITableViewCell in
                let cell = tb.dequeueReusableCell(withIdentifier: self.resuerId) as? normalTableViewCell
                cell?.firstLable?.text = model.descStr
                cell?.secondLable?.text = model.numStr
                
                return cell!
            }.disposed(by: disposeBag)
        }
    
    func RxTableViewEvent() -> Void {
        //cell选中点击事件
        firstTableView.rx.modelSelected(DataModel.self).subscribe(onNext: { [weak self](model) in
            print("modelSelected触发了cell点击，\(model)")
            self?.navigationController?.pushViewController(SectionTableViewVC(), animated: true)
        })
            .disposed(by: disposeBag)
        
        //同样为cell选中点击事件订阅响应，但itemSelected订阅代码总是不提示，无奈
        firstTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("itemSelected触发了cell点击，\(indexPath)")
        })
            .disposed(by: disposeBag)
        
        //订阅cell删除事件
        firstTableView.rx.itemDeleted.subscribe(onNext: { (indexPath) in
            print("删除了第\(indexPath.row)个cell")
        })
            .disposed(by: disposeBag)
        
        //订阅cell移动事件
        firstTableView.rx.itemMoved.subscribe(onNext: { (sourceIndexPath,desIndexPath) in
            print("从\(sourceIndexPath)移动到\(desIndexPath)")
        })
            .disposed(by: disposeBag)
    }
}


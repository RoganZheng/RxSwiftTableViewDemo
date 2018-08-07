//
//  TableViewDataModel.swift
//  RxSwift--tableview
//
//  Created by drogan Zheng on 2018/8/7.
//  Copyright © 2018年 RxSwift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//普通tableView数据源结构体
struct DataModel {
    let descStr:String
    let numStr:String
}

//普通tableView的data数据源
struct FirstTableViewModel {
    var arr = Array<DataModel>()
    init() {
        arr.append(DataModel(descStr: "first", numStr: "number 1"))
        arr.append(DataModel(descStr: "second", numStr: "number 2"))
        arr.append(DataModel(descStr: "third", numStr: "number 3"))
        arr.append(DataModel(descStr: "fourth", numStr: "number 4"))
        arr.append((DataModel(descStr: "fifth", numStr: "number 5")))
    }
}

//组tableView数据结构体
struct SectionDataModel {
    let firstName:String
    let secondName:String
    var image:UIImage?
    
    init(firstName:String, secondName:String) {
        self.firstName = firstName
        self.secondName = secondName
        image = UIImage(named: secondName)
    }
}

extension SectionDataModel:IdentifiableType{
    typealias Identity = String
    var identity:Identity {return secondName}
    
}

class TableViewDataModel{

}

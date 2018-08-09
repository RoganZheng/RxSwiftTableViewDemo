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

//使用RxDataSources的唯一限制是，section中使用的每个类型都必须符合IdentifiableType和Equatable协议。
//IdentifiableType声明一个唯一的标识符（在同一具体类型的对象中是唯一的），以便RxDataSources唯一标识对象
extension SectionDataModel:IdentifiableType{
    typealias Identity = String
    var identity:Identity {return secondName}
    
}

//分组tableView数据源
class sectionData{
    let sectionArr = Observable.just([
        SectionModel(model: "one", items: [
            SectionDataModel(firstName: "plan A", secondName: "A description"),
            SectionDataModel(firstName: "plan B", secondName: "B descriptiopn"),
            ]),
        SectionModel(model: "two", items: [
            SectionDataModel(firstName: "plan AA", secondName: "AA description"),
            SectionDataModel(firstName: "plan BB", secondName: "BB description"),
            SectionDataModel(firstName: "plan CC", secondName: "CC description"),
            ]),
        SectionModel(model: "three", items: [
            SectionDataModel(firstName: "plan AAA", secondName: "AAA description"),
            SectionDataModel(firstName: "plan BBB", secondName: "BBB description"),
            SectionDataModel(firstName: "plan CCC", secondName: "CCC description"),
            SectionDataModel(firstName: "plan DDD", secondName: "DDD description"),
            ])
        ])
    
}

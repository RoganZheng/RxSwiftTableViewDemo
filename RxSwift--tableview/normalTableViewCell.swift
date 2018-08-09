//
//  normalTableViewCell.swift
//  RxSwift--tableview
//
//  Created by drogan Zheng on 2018/8/9.
//  Copyright © 2018年 RxSwift. All rights reserved.
//

import UIKit

class normalTableViewCell: UITableViewCell {
    var firstLable:UILabel?
    var secondLable:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.firstLable = UILabel()
        self.contentView.addSubview(self.firstLable!)
        
        self.secondLable = UILabel()
        self.contentView.addSubview(self.secondLable!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.firstLable?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.width.equalTo(150)
            make.height.equalTo(self.contentView.snp.height)
        })
        self.secondLable?.snp.makeConstraints({ (make) in
            make.left.equalTo((self.firstLable?.snp.right)!).offset(10)
            make.centerY.equalTo((self.firstLable?.snp.centerY)!)
            make.width.equalTo((self.firstLable?.snp.width)!)
            make.height.equalTo((self.firstLable?.snp.height)!)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented yet")
    }
    
    func getValue(firstStr:String, secondStr:String) -> Void {
        self.firstLable?.text = firstStr
        self.secondLable?.text = secondStr
    }
}

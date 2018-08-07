//
//  ViewController.swift
//  RxSwift--tableview
//
//  Created by drogan Zheng on 2018/7/5.
//  Copyright © 2018年 RxSwift. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {
    
    lazy var firstTableView: UITableView = UITableView()
    let resuerId:String = "firstCell"
    
    let disposeBag = DisposeBag()
    let firstText = UITextField()
    let secondLable = UILabel()
    let thirdBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        createView()
//        createObservable()
    }
}

extension ViewController{
    
    func createView() -> Void {
        
        firstText.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(firstText)
        firstText.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(50)
            make.right.equalTo(self.view.snp.right).offset(-50)
            make.height.equalTo(44)
            make.top.equalTo(self.view.snp.top).offset(80)
        }
        
        
        secondLable.textColor = UIColor.white
        secondLable.backgroundColor = UIColor.purple
        secondLable.layer.masksToBounds = true
        secondLable.layer.cornerRadius = 5;
        self.view.addSubview(secondLable)
        secondLable.snp.makeConstraints { (make) in
            make.top.equalTo(firstText.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(firstText.snp.width).offset(-50)
            make.height.equalTo(50)
        }
        
        
        thirdBtn.setTitle("按钮", for: UIControlState.normal)
        thirdBtn.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.view.addSubview(thirdBtn)
        thirdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secondLable.snp.bottom).offset(50)
            make.centerX.equalTo(secondLable.snp.centerX)
            make.width.height.equalTo(secondLable)
        }

    }
    func bindViewModel() -> Void {
        let inputTextOb = firstText.rx.text
            .orEmpty
            .asDriver() //过滤error信号
            .throttle(0.5)  //每隔指定时间发送信号
        
        //将text输入内容实时返回给lable.text属性中
        inputTextOb.map{ "当前输入为：\($0)"}
            .drive(secondLable.rx.text)
            .disposed(by: disposeBag)
        
        //直接使用map映射序列给btn，判断是否可点击
        inputTextOb.map{$0.count >= 5}
            .drive(thirdBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //作为观察者序列，将lable的text与btn的title属性进行绑定
        inputTextOb.asObservable()
            .bind(to: thirdBtn.rx.title())
            .disposed(by: disposeBag)
        
//        inputTextOb.map{"按钮内容为：\($0)"}
//            .drive(thirdBtn.rx.title())
//            .disposed(by: disposeBag)
        
        
        //btn点击响应事件
        thirdBtn.rx.tap.subscribe(onNext: { [weak self]() in
            self?.view.backgroundColor = UIColor.blue
            print("点击事件发生")
            self?.thirdBtn.backgroundColor = UIColor.red
            self?.navigationController?.pushViewController(TableViewViewController(), animated: true)
        }).disposed(by: disposeBag)
        
    }
}

extension ViewController {
    func createObservable() -> Void {
        //通过指定的方法实现来自定义一个被观察的序列。
        //订阅创建
        let myOb = Observable<Any>.create { (observ) -> Disposable in
            observ.onNext("cooci")
            observ.onCompleted()
            return Disposables.create()
        }
        //订阅事件
        myOb.subscribe { (even) in
            print(even)
            }.disposed(by: disposeBag)//销毁
        
        //各种观察者序列产生方式
        
        //该方法通过传入一个默认值来初始化。
        Observable.just("just")
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        let createJustObservable = Observable.just("one")
        createJustObservable.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        
        //该方法可以接受可变数量的参数（必需要是同类型的）
        Observable.of("o","f","of").subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        //该方法需要一个数组参数。
        Observable.from(["f","r","o","m"])
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
        Observable<Int>.never()
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //该方法创建一个空内容的 Observable 序列。 //会打印complete
        Observable<Int>.empty()
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
        let myError = MyError.A
        //        print(myError.errorType)
        Observable<Int>.error(myError)
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列。
        Observable
            .range(start: 1, count: 6)
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //该方法创建一个可以无限发出给定元素的 Event的 Observable 序列（永不终止）。
        //            Observable.repeatElement("repeat")
        //                .subscribe { (event) in
        //                print(event)
        //            }
        //                .disposed(by: disposeBag)
        
        //该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
        //第一个参数:初始化的数值  第二个 条件  第三也是一个条件 0 + 2 <= 10 依次循环下去,iterate:重复执行
        Observable
            .generate(initialState: 0, condition: {$0<=10}, iterate: {$0+2})
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //上面和下面的效果一样
        Observable.of(0,2,4,6,8,10)
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        //该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
        var isOdd = true
        let factory: Observable<Int> = Observable
            .deferred { () -> Observable<Int> in
                
                isOdd = !isOdd
                if isOdd{
                    return Observable.of(0,2,4,6,8)
                }else{
                    return Observable.of(1,3,5,7,9)
                }
        }
        
        factory.subscribe { (event) in
            print("\(isOdd)",event)
            }
            .disposed(by: disposeBag)
        
        factory.subscribe { (event) in
            print("\(isOdd)",event)
            }.disposed(by: disposeBag)
        
        
        //这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
        
        //        Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe { (event) in
        //            print(event)
        //        }.disposed(by: disposeB)
        
        //这个方法有两种用法，一种是创建的 Observable序列在经过设定的一段时间后，产生唯一的一个元素。
        Observable<Int>
            .timer(1, scheduler: MainScheduler.instance).subscribe{(event) in
                print("scheduler",event)
            }
            .disposed(by: disposeBag)
        //
        //
        //另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
        Observable<Int>
            .timer(5, period: 1, scheduler: MainScheduler.instance).subscribe { (event) in
                print("timer",event)
            }
            .disposed(by: disposeBag)
    }
}

enum MyError:Error {
    case A
    case B
    var errorType:String {
        switch self {
        case .A:
            return "i am error A"
        case .B:
            return "BBBB"
        }
    }
}


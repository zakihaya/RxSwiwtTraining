//
//  ViewController.swift
//  RxSwiftTraining
//
//  Created by haayzaki on 2020/11/06.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var asyncButton: UIButton!
    
    @IBAction func asyncButtonTapped(_ sender: Any) {
        print("asyncButtonTapped")
        
        asyncMethod2()
            .flatMap({ obj -> Single<Int> in
                print("main flatMap1 \(obj)")
                return .just(1)
            })
            .flatMap({ [unowned self] obj -> Single<String> in
                print("main flatMap2 \(obj)")
                return self.asyncMethod1()
            })
            .subscribe(onNext: { obj in
                print("main subscribe \(obj)")
            })
            .disposed(by: self.disposeBag)
            
        
        print("asyncButtonTapped end")
    }
    
    private func asyncMethod1() -> Single<String> {
        print("asyncMethod1")
        if countLabel.text == "0" {
            return .error(NSError(domain: "asyncMethod1", code: 1, userInfo: nil))
        }
        return .just(countLabel.text!)
    }
    
    private func asyncMethod2() -> Observable<String> {
        print("asyncMethod2")
        return Observable.create({ observer in
            print("asyncMethod2 observable")
            sleep(1)
            observer.onNext("val1")
            sleep(1)
            observer.onNext("val2")
            return Disposables.create()
        })
    }
    
    
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bindActions()
    }
    
    private func bindActions() {
        self.plusButton.rx.tap
            .asObservable()
            .map({ [weak self] _ in
                self?.count += 1
            })
            .subscribe(onNext: {
                self.refreshCountLabel()
            })
            .disposed(by: self.disposeBag)
        
        self.minusButton.rx.tap
            .asObservable()
            .map({ [weak self] _ in
                self?.count -= 1
            })
            .subscribe(onNext: {
                self.refreshCountLabel()
            })
            .disposed(by: self.disposeBag)
        
        self.resetButton.rx.tap
            .asObservable()
            .map({ [weak self] _ in
                self?.count = 0
            })
            .subscribe(onNext: {
                self.refreshCountLabel()
            })
            .disposed(by: self.disposeBag)
    }

    private func refreshCountLabel() {
        self.countLabel.text = String(count)
    }

}


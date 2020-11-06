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


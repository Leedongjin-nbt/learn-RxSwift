//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift

example(of: "ignoreElements") {
    let strikes = PublishSubject<String>()
    let disposBag = DisposeBag()
    
    strikes
        .ignoreElements()
        .subscribe({ _ in
            print("You're Out!")
        })
    
    strikes.onNext("HAHAHA")
    strikes.onCompleted()
}

example(of: "elementAt") {
    let strikes = PublishSubject<String>()
    let disposBag = DisposeBag()
    
    strikes
        .elementAt(2)
        .subscribe(onNext: { _ in
            print("wow")
        }).disposed(by: disposBag)
    
    strikes.onNext("1")
    strikes.onNext("2")
    strikes.onNext("3")
    
}

example(of: "filter") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6)
        .filter { $0 % 2 == 0 }
        .subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
    
}

example(of: "skip") {
    let disposeBag = DisposeBag()
    
    Observable.of("A","B","C","D","E")
        .skip(3)
        .subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
}

example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,1,3,4,5,6,6,7)
        .skipWhile { $0 % 2 == 1 }
        .subscribe(onNext :{
            print($0)
        }).disposed(by: disposeBag)
}

example(of: "skipUntil") {
    let disposeBag = DisposeBag()
    let trigger = PublishSubject<Int>()
    let mainStream = PublishSubject<Int>()
    
    mainStream
        .skipUntil(trigger)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    mainStream.onNext(1)
    mainStream.onNext(3)
    trigger.onNext(10)
    mainStream.onNext(2)
    
}

//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift

//example(of: "ignoreElements") {
//    let strikes = PublishSubject<String>()
//    let disposBag = DisposeBag()
//
//    strikes
//        .ignoreElements()
//        .subscribe({ _ in
//            print("You're Out!")
//        })
//
//    strikes.onNext("HAHAHA")
//    strikes.onCompleted()
//}
//
//example(of: "elementAt") {
//    let strikes = PublishSubject<String>()
//    let disposBag = DisposeBag()
//
//    strikes
//        .elementAt(2)
//        .subscribe(onNext: { _ in
//            print("wow")
//        }).disposed(by: disposBag)
//
//    strikes.onNext("1")
//    strikes.onNext("2")
//    strikes.onNext("3")
//
//}
//
//example(of: "filter") {
//    let disposeBag = DisposeBag()
//
//    Observable.of(1,2,3,4,5,6)
//        .filter { $0 % 2 == 0 }
//        .subscribe(onNext: { element in
//            print(element)
//        }).disposed(by: disposeBag)
//
//}
//
//example(of: "skip") {
//    let disposeBag = DisposeBag()
//
//    Observable.of("A","B","C","D","E")
//        .skip(3)
//        .subscribe(onNext: { element in
//            print(element)
//        }).disposed(by: disposeBag)
//}
//
example(of: "skipWhile") {
    let disposeBag = DisposeBag()

    Observable.of(1,1,3,4,5,6,6,7)
        .skipWhile { $0 % 2 == 1 }
        .subscribe(onNext :{
            print($0)
        }).disposed(by: disposeBag)
}
//
//example(of: "skipUntil") {
//    let disposeBag = DisposeBag()
//    let trigger = PublishSubject<Int>()
//    let mainStream = PublishSubject<Int>()
//
//    mainStream
//        .skipUntil(trigger)
//        .subscribe(onNext: { print($0) })
//        .disposed(by: disposeBag)
//
//    mainStream.onNext(1)
//    mainStream.onNext(3)
//    trigger.onNext(10)
//    mainStream.onNext(2)
//
//}
//
//example(of: "take") {
//    let disposeBag = DisposeBag()
//
//    Observable.of(1,2,3,4,5,6)
//        .take(3)
//        .subscribe(onNext: { print($0) })
//        .disposed(by: disposeBag)
//}
//
//example(of: "takeWhile") {
//    let disposeBag = DisposeBag()
//
//    Observable.of(2,2,3,4,6,6,7)
//        .enumerated()
//        .takeWhile { index, integer in
//            integer % 2 == 0 && index < 5
//    }
//        .map { $0.element }
//        .subscribe(onNext: {
//            print($0)
//        }).disposed(by: disposeBag)
//
//    Observable.of(2,2,3,4,4)
//        .takeWhile { element in
//            element % 2 == 0
//    }
//        .subscribe(onNext: {
//            print($0)
//        }).disposed(by: disposeBag)
//}
//
//example(of: "takeUntil") {
//    let disposeBag = DisposeBag()
//    let trigger = PublishSubject<String>()
//    let subject = PublishSubject<String>()
//
//    subject.subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//    subject.onNext("1")
//    subject.onNext("2")
//
//    trigger.onNext("X")
//
//    subject.onNext("3")
//}

example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,2,3,3,4,3,4,4,4,5)
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}

example(of: "distinctUntilChanged(_:)") {
    let disposeBag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    let words1 = formatter.string(from: 10)?.components(separatedBy: " ")
    let words2 = formatter.string(from: 20)?.components(separatedBy: " ")
    
    Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
        .distinctUntilChanged { a, b in
            
            guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }

            var containsMatch = false

            for aWord in aWords {
                for bWord in bWords {
                    if aWord == bWord {
                        containsMatch = true
                        break
                    }
                }
            }
            return containsMatch
        }
        .subscribe(onNext: {
            print("Subscribe: \($0)")
        }).disposed(by: disposeBag)
}

example(of: "Challenge 1") {
    
    let disposeBag = DisposeBag()
    
    let contacts = [
        "603-555-1212": "Florent",
        "212-555-1212": "Junior",
        "408-555-1212": "Marin",
        "617-555-1212": "Scott"
    ]
    
    func phoneNumber(from inputs: [Int]) -> String {
        var phone = inputs.map(String.init).joined()
        
        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 3)
        )
        
        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 7)
        )
        
        return phone
    }
    
    let input = PublishSubject<Int>()
    
    // Add your code here
    input
        .skipWhile { $0 == 0 }
        .filter { $0 < 10 }
        .take(10)
        .toArray()
        .subscribe(onNext: {
            print(phoneNumber(from: $0))
        }).disposed(by: disposeBag)
    
    
    input.onNext(0)
    input.onNext(603)
    
    input.onNext(2)
    input.onNext(1)
    
    // Confirm that 7 results in "Contact not found", and then change to 2 and confirm that Junior is found
    input.onNext(7)
    
    "5551212".characters.forEach {
        if let number = (Int("\($0)")) {
            input.onNext(number)
        }
    }
    
    input.onNext(9)
}

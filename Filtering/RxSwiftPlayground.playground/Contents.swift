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
//example(of: "skipWhile") {
//    let disposeBag = DisposeBag()
//
//    Observable.of(1,1,3,4,5,6,6,7)
//        .skipWhile { $0 % 2 == 1 }
//        .subscribe(onNext :{
//            print($0)
//        }).disposed(by: disposeBag)
//}
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

//example(of: "distinctUntilChanged") {
//    let disposeBag = DisposeBag()
//
//    Observable.of(1,2,2,3,3,4,3,4,4,4,5)
//        .distinctUntilChanged()
//        .subscribe(onNext: {
//            print($0)
//        }).disposed(by: disposeBag)
//}
//
//example(of: "distinctUntilChanged(_:)") {
//    let disposeBag = DisposeBag()
//
//    let formatter = NumberFormatter()
//    formatter.numberStyle = .spellOut
//
//    let words1 = formatter.string(from: 10)?.components(separatedBy: " ")
//    let words2 = formatter.string(from: 20)?.components(separatedBy: " ")
//
//    Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
//        .distinctUntilChanged { a, b in
//
//            guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
//                let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
//
//            var containsMatch = false
//
//            for aWord in aWords {
//                for bWord in bWords {
//                    if aWord == bWord {
//                        containsMatch = true
//                        break
//                    }
//                }
//            }
//            return containsMatch
//        }
//        .subscribe(onNext: {
//            print("Subscribe: \($0)")
//        }).disposed(by: disposeBag)
//}
//
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
//
struct Student {
    var score: BehaviorSubject<Int>
}
//
example(of: "flatMap") {

    let disposeBag = DisposeBag()

    let ryan = Student(score: BehaviorSubject(value: 10))
    let charlotte = Student(score: BehaviorSubject(value: 20))
    let ethan = Student(score: BehaviorSubject(value: 30))

    let student = PublishSubject<Student>()

    student
        .flatMapLatest {
            $0.score
        }
        .subscribe( onNext: {
            print ($0)
        }).disposed(by: disposeBag)

    student.onNext(ryan)
    student.onNext(charlotte)
    student.onNext(ethan)

    ryan.score.onNext(40)
    charlotte.score.onNext(50)
    ryan.score.onNext(60)

}

example(of: "materialize and dematerialize") {
    enum MyError: Error {
        case anError
    }

    let disposedBag = DisposeBag()

    let ryan = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))

    let student = BehaviorSubject(value: ryan)

    student
        .flatMapLatest {
            $0.score.materialize()
        }
        .filter {
            guard $0.error == nil else {
                print($0.error!)
                return false
            }
            return true
        }
        .dematerialize()
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposedBag)

    ryan.score.onNext(85)
    ryan.score.onError(MyError.anError)
    ryan.score.onNext(90)

    student.onNext(charlotte)
}

example(of: "Challenge 1") {
    let disposeBag = DisposeBag()
    
    let contacts = [
        "603-555-1212": "Florent",
        "212-555-1212": "Junior",
        "408-555-1212": "Marin",
        "617-555-1212": "Scott"
    ]
    
    let convert: (String) -> UInt? = { value in
        if let number = UInt(value),
            number < 10 {
            return number
        }
        
        let keyMap: [String: UInt] = [
            "abc": 2, "def": 3, "ghi": 4,
            "jkl": 5, "mno": 6, "pqrs": 7,
            "tuv": 8, "wxyz": 9
        ]
        
        let converted = keyMap
            .filter { $0.key.contains(value.lowercased()) }
            .map { $0.value }
            .first
        
        return converted
    }
    
    let format: ([UInt]) -> String = {
        var phone = $0.map(String.init).joined()
        
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
    
    let dial: (String) -> String = {
        if let contact = contacts[$0] {
            return "Dialing \(contact) (\($0))..."
        } else {
            return "Contact not found"
        }
    }
    
    let input = Variable<String>("")
    
    // Add your code here
    
    input.asObservable()
        .map(convert)
        .skipWhile { $0 == 0 }
        .take(10)
        .toArray()
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    
    input.value = ""
    input.value = "0"
    input.value = "408"
    
    input.value = "6"
    input.value = ""
    input.value = "0"
    input.value = "3"
    
    "JKL1A1B".forEach {
        input.value = "\($0)"
    }
    
    input.value = "9"
}

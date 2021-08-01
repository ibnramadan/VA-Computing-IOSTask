//
//  CalculatorViewModel.swift
//  VAComputingIOSTask
//
//  Created by iMac on 31/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

class CalculatorViewModel {
    
    var firstOperandBehavior = BehaviorRelay<String>(value : "")
    var secondOperandBehavior = BehaviorRelay<String>(value : "")
    var operatorBehavior = BehaviorRelay<String>(value : "")
    var taskTimeBehavior = BehaviorRelay<String>(value : "")
    var resultBehavior = BehaviorRelay<String>(value : "")
    var clearDataBehavior = BehaviorRelay<Bool>(value: false)
    
    private var resultSubject = PublishSubject<String>()

    var resultSubjectObservable: Observable<String> {
        return resultSubject
    }
    
    
    var equations : [String] = []
    var recievedResults : [String] = []
    private var isEquationsTableHidden = BehaviorRelay<Bool>(value: false)
    var isEquationsTableHiddenObservable: Observable<Bool> {
        return isEquationsTableHidden.asObservable()
    }
    private var EquationsModelSubject = PublishSubject<[String]>()
    var EquationsModelObservable: Observable<[String]> {
        return EquationsModelSubject
    }
  
    
    private var isRecievedResultsTableHidden = BehaviorRelay<Bool>(value: false)
    var isRecievedResultsTableHiddenObservable: Observable<Bool> {
        return isEquationsTableHidden.asObservable()
    }
    private var RecievedResultsModelSubject = PublishSubject<[String]>()
    var RecievedResultsModelObservable: Observable<[String]> {
        return RecievedResultsModelSubject
    }
    
    
    var firstOperandValid : Observable<Bool> {
        firstOperandBehavior.asObservable().map { firstOperand -> Bool in
            return firstOperand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var operatorValid : Observable<Bool> {
        operatorBehavior.asObservable().map { _operator -> Bool in
            return _operator.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var secondOperandValid: Observable<Bool> {
        return secondOperandBehavior.asObservable().map {(secondOperand) -> Bool in
            let ISsecondOperandBehaviorEmpty = secondOperand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return ISsecondOperandBehaviorEmpty
        }
    }
    
    var taskTimeValid : Observable<Bool> {
        taskTimeBehavior.asObservable().map { taskTime -> Bool in
            return taskTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var isCalculateButtonEnapled: Observable<Bool> {
        return Observable.combineLatest(firstOperandValid, secondOperandValid , operatorValid,taskTimeValid) { (isfirstOperandEmpty, issecondOperandEmpty,isoperatorEmpty, istaskTimeEmpty ) in
            let calculateValid = !isfirstOperandEmpty && !issecondOperandEmpty &&  !isoperatorEmpty && !istaskTimeEmpty
            return calculateValid
        }
        
    }
    
    func clearData() {
        clearDataBehavior.accept(true)
        }
    
    func calculateEquation() {

        let equation = firstOperandBehavior.value + operatorBehavior.value + secondOperandBehavior.value
        equations.append(equation)
        self.EquationsModelSubject.onNext(equations)
        self.isEquationsTableHidden.accept(false)
        let expn = NSExpression(format:equation)
        let taskTime = Double(taskTimeBehavior.value) ?? 0.0
        let deadline = DispatchTime.now() + taskTime
        DispatchQueue.main.asyncAfter(deadline: deadline) { [self] in
            if let result  =  expn.expressionValue(with: nil, context: nil)  {
                  self.resultSubject.onNext("\(result)")
                recievedResults.append("\(equation) = \(result)")
                self.RecievedResultsModelSubject.onNext(recievedResults)
                self.isRecievedResultsTableHidden.accept(false)
            }
        }
     
        }
  
}


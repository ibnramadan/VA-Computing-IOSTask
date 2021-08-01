//
//  CalculatorViewController.swift
//  VAComputingIOSTask
//
//  Created by iMac on 31/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
class CalculatorViewController: UIViewController {
    
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var firstOperandTF: UITextField!
    @IBOutlet weak var secondOperandTF: UITextField!
    @IBOutlet weak var operatorTF: UITextField!
    @IBOutlet weak var taskTimeTF: UITextField!
    @IBOutlet weak var resultTF: UITextField!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var equatuinsTableView: UITableView!
    @IBOutlet weak var resultRecievedTableView: UITableView!
    
    @IBOutlet weak var equationsStackView: UIStackView!
    
    var operators = ["+","-","*","/"]
    var taskTimes = ["5","10","15","20", "25","30","35","40","45","50"]
    var operatorPicker: ToolbarPickerView! = ToolbarPickerView()
    var taskTimesPicker: ToolbarPickerView! = ToolbarPickerView()
    var equation = ""
    let equationCell = "EquationCell"
    //handle memory manual
    let disposeBag = DisposeBag()
    let calculatorViewModel = CalculatorViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOperatorPicker()
        setupTaskTimesPicker()
        bindTextFieldsToViewModel()
        subscribeToResponse()
        subscribeIsCalculateEnabled()
        subscribeToCalculatorButton()
        subscribeToClearButton()
        subscribeToClearData()
        setupTableView()
        bindToHiddenEquatuinsTableView()
        bindToRecievedResultsTableView()
        subscribeToEquationsTableResponse()
        subscribeToRecievedResultTableResponse()
    }
    func setupTableView() {

        equatuinsTableView.register(UINib(nibName: equationCell, bundle: nil), forCellReuseIdentifier: equationCell)
        resultRecievedTableView.register(UINib(nibName: equationCell, bundle: nil), forCellReuseIdentifier: equationCell)
        
    }
    func bindToHiddenEquatuinsTableView() {
        calculatorViewModel.isEquationsTableHiddenObservable.bind(to: self.equationsStackView.rx.isHidden).disposed(by: disposeBag)
    }
    
    func bindToRecievedResultsTableView() {
        calculatorViewModel.isRecievedResultsTableHiddenObservable.bind(to: self.equatuinsTableView.rx.isHidden).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in views {
            view.addShadowForAllSides()
        }
    }
    
    func  bindTextFieldsToViewModel(){
        firstOperandTF.rx.text.orEmpty.bind(to: calculatorViewModel.firstOperandBehavior).disposed(by: disposeBag)
        secondOperandTF.rx.text.orEmpty.bind(to: calculatorViewModel.secondOperandBehavior).disposed(by: disposeBag)
        operatorTF.rx.text.orEmpty.bind(to: calculatorViewModel.operatorBehavior).disposed(by: disposeBag)
        taskTimeTF.rx.text.orEmpty.bind(to: calculatorViewModel.taskTimeBehavior).disposed(by: disposeBag)
        resultTF.rx.text.orEmpty.bind(to: calculatorViewModel.resultBehavior).disposed(by: disposeBag)
    }

 
    
    func subscribeToResponse() {
        calculatorViewModel.resultSubjectObservable.subscribe(onNext: {
            if $0 != "" {
                self.resultTF.text = $0
            } else {

            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToClearData() {
        calculatorViewModel.clearDataBehavior.subscribe(onNext: { (isClear) in
            if isClear {
                self.resetData()
            }else {
                // no change
            }
            
        }).disposed(by: disposeBag)
    }
    func subscribeIsCalculateEnabled() {
        calculatorViewModel.isCalculateButtonEnapled.bind(to: calculateBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    func subscribeToCalculatorButton() {
        calculateBtn.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.calculatorViewModel.calculateEquation()
        }).disposed(by: disposeBag)
    }
    
    func subscribeToClearButton() {
        clearBtn.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.calculatorViewModel.clearData()
        }).disposed(by: disposeBag)
    }
    func setupOperatorPicker() {
        operatorTF.delegate = self
        self.operatorTF.inputView = operatorPicker
        self.operatorTF.inputAccessoryView = self.operatorPicker.toolbar
        self.operatorPicker.dataSource = self
        self.operatorPicker.delegate = self
        self.operatorPicker.toolbarDelegate = self
        self.operatorPicker.reloadAllComponents()
    }
    func setupTaskTimesPicker() {
        taskTimeTF.delegate = self
        self.taskTimeTF.inputView = taskTimesPicker
        self.taskTimeTF.inputAccessoryView = self.taskTimesPicker.toolbar
        self.taskTimesPicker.dataSource = self
        self.taskTimesPicker.delegate = self
        self.taskTimesPicker.toolbarDelegate = self
        self.taskTimesPicker.reloadAllComponents()
        
    }
    
    func resetData(){
        self.firstOperandTF.text = ""
        self.secondOperandTF.text = ""
        self.operatorTF.text = ""
        self.taskTimeTF.text = ""
        self.resultTF.text = ""
    }
    

    func subscribeToEquationsTableResponse() {
        self.calculatorViewModel.EquationsModelObservable
            .bind(to: self.equatuinsTableView
                .rx
                .items(cellIdentifier: equationCell,
                       cellType: EquationCell.self)) { row, equation, cell in
                        print(row)
                        cell.textLabel?.text = equation
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeToRecievedResultTableResponse() {
  
        self.calculatorViewModel.RecievedResultsModelObservable
            .bind(to: self.resultRecievedTableView
                .rx
                .items(cellIdentifier: equationCell,
                       cellType: EquationCell.self)) { row, equation, cell in
                        print(row)
                        cell.textLabel?.text = equation
        }
        .disposed(by: disposeBag)
    }
    
    
}
extension CalculatorViewController : UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //MARK: - Pickerview method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case operatorPicker:
            return operators.count
        case taskTimesPicker:
            return taskTimes.count
        default:
            return operators.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case operatorPicker:
            return operators[row]
        case taskTimesPicker:
            return taskTimes[row]
        default:
            return operators[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        //  operatorPicker.isHidden = true
        switch pickerView {
        case operatorPicker:
            self.operatorTF.text = operators[row]
        case taskTimesPicker:
            self.taskTimeTF.text = taskTimes[row]
        default:
            self.operatorTF.text = operators[row]
        }
    }
    
}
extension CalculatorViewController: ToolbarPickerViewDelegate {
    func didTapDone(_ picker: ToolbarPickerView) {
        switch picker {
        case operatorPicker:
            let row = self.operatorPicker.selectedRow(inComponent: 0)
            self.operatorPicker.selectRow(row, inComponent: 0, animated: false)
            self.operatorTF.text = self.operators[row]
            self.operatorTF.resignFirstResponder()
        case taskTimesPicker:
            let row = self.taskTimesPicker.selectedRow(inComponent: 0)
            self.taskTimesPicker.selectRow(row, inComponent: 0, animated: false)
            self.taskTimeTF.text = self.taskTimes[row]
            self.taskTimeTF.resignFirstResponder()
        default:
        return
        }
    }
    
    func didTapCancel(_ picker: ToolbarPickerView) {
        switch picker {
        case operatorPicker:
            self.operatorTF.text = nil
            self.operatorTF.resignFirstResponder()
        case taskTimesPicker:
            self.taskTimeTF.text = nil
            self.taskTimeTF.resignFirstResponder()
        
        default:
            return
        }
    }
    
    
 
}


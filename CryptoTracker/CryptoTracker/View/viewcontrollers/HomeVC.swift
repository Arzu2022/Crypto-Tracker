//
//  ViewController.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    weak var mainCoordinator:MainCoordinator?
    private lazy var titleLbl:UILabel = {
        let text = UILabel()
        text.text = "Coins Tracker"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return text
    }()
    private lazy var historyBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("History", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.addTarget(self, action: #selector(onClickHistory), for: .touchUpInside)
        return btn
    }()
    private lazy var coinsTV:UITableView = {
        let view = UITableView()
        view.register(HomeCoinsTVCell.self, forCellReuseIdentifier: "coinsCell")
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .black
        return view
    }()
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeViewModel.shared.getAllCoins().then { bool in
            if bool {
                self.setupUI()
                self.coinsTV.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HomeViewModel.shared.getAllCoins().then { bool in
            if bool {
                self.setupUI()
                self.coinsTV.reloadData()
            }
        }
    }
    //MARK: FUNCTIONS
    private func setupUI(){
        self.view.backgroundColor = .black
        
        self.view.addSubview(titleLbl)
        self.view.addSubview(historyBtn)
        self.view.addSubview(coinsTV)
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(16)
        }
        historyBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.right.equalToSuperview().offset(-16)
        }
        coinsTV.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLbl.snp.bottom).offset(16)
        }
        
    }
    func showAlertForValuesSetting(id:String,name:String) {
        let alertController = UIAlertController(title: "Set Values", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter min value"
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter max value"
            textField.keyboardType = .numberPad
            textField.delegate = self

        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let minTF = alertController.textFields?.first, let minValue = minTF.text,
               let maxTF = alertController.textFields?.last, let maxValue = maxTF.text {
                if minValue == "" || maxValue == "" {
                    self.showToast(message: "Enter num then save!!!", seconds: 2)
                } else {
                    
                    let maxCheck = Double(maxValue)
                    let minCheck = Double(minValue)
                    if maxCheck! <= minCheck! {
                        self.showToast(message: "Max value must be greater than min value!!", seconds: 2)
                    } else {
                        var arr:[HistoryModel] = []
                        var checkValue:Bool = false
                        if let historyValue = UserDefaults.standard.object(forKey: "history"){
                            let decoder = JSONDecoder()
                            arr = try! decoder.decode([HistoryModel].self, from: historyValue as! Data)
                        }
                        for i in arr {
                            if i.id == id {
                                checkValue = true
                                break
                            }
                        }
                        if !checkValue {
                            arr.append(HistoryModel(id: id, name: name, min: minValue, max: maxValue))
                        } else {
                            self.showToast(message: "This coin is already exist", seconds: 2)
                        }
                        do {
                            let encoder = JSONEncoder()
                            let encodedData = try encoder.encode(arr)
                            UserDefaults.standard.set(encodedData, forKey: "history")
                            
                        } catch {
                            print("Error encoding struct: \(error)")
                        }
                    }
                }
            }
        }
        alertController.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
        
    }

    //MARK: UIFUNCTIONS
    @objc func onClickHistory(){
        self.mainCoordinator?.history()
    }

}
extension HomeVC:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeViewModel.shared.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinsCell", for: indexPath) as! HomeCoinsTVCell
        cell.name.text = HomeViewModel.shared.data[indexPath.row].name
        cell.price.text = "\(String(format: "%.2f", HomeViewModel.shared.data[indexPath.row].current_price!))$"
        cell.symbol.text = HomeViewModel.shared.data[indexPath.row].symbol
        cell.urlToImage.imageFromServerURL(HomeViewModel.shared.data[indexPath.row].image!, placeHolder: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlertForValuesSetting(id: HomeViewModel.shared.data[indexPath.row].id, name: HomeViewModel.shared.data[indexPath.row].name)
    }
    
    //MARK: TEXTFIELD FUNCTIONS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let numberRegex = "^[0-9]*$"
        let regex = try! NSRegularExpression(pattern: numberRegex)
        let matches = regex.matches(in: newText, range: NSRange(location: 0, length: newText.count))
        return matches.count > 0
    }
    
}


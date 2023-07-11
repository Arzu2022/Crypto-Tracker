//
//  HistoryVC.swift
//  CryptoTracker
//
//  Created by AziK's  MAC
//

import UIKit
import SnapKit

class HistoryVC: UIViewController {
    private lazy var titleLbl:UILabel = {
        let text = UILabel()
        text.text = "History Page"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return text
    }()
    private lazy var noHistoryLbl:UILabel = {
        let text = UILabel()
        text.text = "There is no historied coins."
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return text
    }()
    private lazy var historiedCoinsTV:UITableView = {
        let view = UITableView()
        view.register(HistoryCoinsTVCell.self, forCellReuseIdentifier: "historiedCoinsCell")
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .black
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryViewModel.shared.fetchData().then { bool in
            self.setupUI()
            if bool {
                self.noHistoryLbl.removeFromSuperview()
            } else {
                self.historiedCoinsTV.removeFromSuperview()
                self.setNoHistory()
            }
        }
    }
    private func setNoHistory(){
        self.view.addSubview(noHistoryLbl)
        noHistoryLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    private func setupUI(){
        self.view.backgroundColor = .black
        self.view.addSubview(titleLbl)
        self.view.addSubview(historiedCoinsTV)
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        historiedCoinsTV.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLbl.snp.bottom).offset(10)
        }

    }

}
extension HistoryVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HistoryViewModel.shared.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historiedCoinsCell", for: indexPath) as! HistoryCoinsTVCell
        cell.name.text = HistoryViewModel.shared.data[indexPath.row].name
        cell.min.text = "Min: \(HistoryViewModel.shared.data[indexPath.row].min)"
        cell.max.text = "Max: \(HistoryViewModel.shared.data[indexPath.row].max)"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dataDecoded = UserDefaults.standard.object(forKey: "history")
            let decoder = JSONDecoder()
            var data = try! decoder.decode([HistoryModel].self, from: dataDecoded as! Data)
            data.remove(at: indexPath.row)
            HistoryViewModel.shared.data.remove(at: indexPath.row)
            do {
                let encoder = JSONEncoder()
                let encodedData = try encoder.encode(data)
                UserDefaults.standard.set(encodedData, forKey: "history")
            } catch {
                print("Error encoding struct: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

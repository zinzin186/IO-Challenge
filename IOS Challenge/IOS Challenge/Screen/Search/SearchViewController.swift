//
//  SearchViewController.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/23/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class SearchViewController: UIViewController {

    
    @IBOutlet weak var searchOptionView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableTopPadding: NSLayoutConstraint!
    @IBOutlet weak var mapOptionView: UIView!
    @IBOutlet weak var chooseMapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let cellId = "CellId"
    private var isSearching: Bool = false
    private var disposeBag = DisposeBag()
    var userViewModel = UserViewModel()
    
    var resultCallback: ((_ place: PlaceModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindUI()
        self.loadHistorySearch()
        self.setupNavi()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func setupNavi(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    private func loadHistorySearch(){
        let listCurrentPlaces = database.objects(PlaceModel.self)
        self.userViewModel.searchResult.accept(Array(listCurrentPlaces))
    }
    private func setupView(){
        [searchOptionView, mapOptionView, tableView].forEach {(view) in
            view?.layer.borderColor = ColorConfig.borderColor.cgColor
            view?.layer.borderWidth = 1.0
        }
        self.tableView.isHidden = true
        self.tableView.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellId)
        self.tableView.separatorStyle = .none
    }
    private func bindUI(){
        self.bindTextField()
        self.bindTableView()
        self.bindButton()
    }
    private func bindTextField(){
        self.searchTextField
        .rx.text
        .orEmpty
        .subscribe(onNext: { [unowned self] query in
            if !query.isEmpty{
                self.isSearching = true
                self.tableTopPadding.constant = -1
                self.tableView.layer.cornerRadius = 0
            }
        })
        .disposed(by: disposeBag)
        self.searchTextField.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance).asObservable().bind(to: self.userViewModel.searchInput).disposed(by: disposeBag)
        self.userViewModel.searchResult.asObservable().bind(to: tableView.rx.items) {[unowned self](tableView, row, element) in
            if self.tableView.isHidden{
                self.tableView.isHidden = false
            }
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! SearchTableViewCell
            cell.nameLabel.text = element.name
            let iconName = self.isSearching ? "ic_qu_place_small": "ic_qu_clock"
            cell.setImageForIcon(image: UIImage(named: iconName))
            cell.addressLabel.text = element.address
            return cell
            }
        .disposed(by: disposeBag)
    }
    private func bindTableView(){
        tableView
            .rx.modelSelected(PlaceModel.self)
            .subscribe(onNext: {[unowned self] place in
                self.savePlace(place: place)
                self.gotoMapView(place: place)
            })
            .disposed(by: disposeBag)
        self.backButton.rx.tap
        .bind {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
    }
    private func bindButton(){
        self.chooseMapButton.rx.tap
        .bind {[unowned self] in
            let vc = CustomMapViewController(nibName: "CustomMapViewController", bundle: nil)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        .disposed(by: disposeBag)
    }
    private func gotoMapView(place: PlaceModel){
        self.navigationController?.popViewController(animated: false)
        self.resultCallback?(place)
        
    }
    private func savePlace(place: PlaceModel){
        try! database.write{
            database.create(PlaceModel.self, value: place, update: .modified)
        }
    }

}
extension SearchViewController: CustomMapViewDelegate{
    func selectedPlace(_ place: PlaceModel) {
        self.savePlace(place: place)
        self.gotoMapView(place: place)
    }
}
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching{
            return nil
        }
        return createHeaderView()
    }
    private func createHeaderView()->UIView{
        let headerView = UIView()
        let label = UILabel()
        label.text = "Recent history"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 0:50
    }
}
extension SearchViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//
//  UserViewModel.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/24/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GooglePlaces


class UserViewModel: NSObject{
    var searchInput = BehaviorRelay<String>(value: "")
    var searchResult = BehaviorRelay<[PlaceModel]>(value: [])
    private var disposeBag = DisposeBag()
    override init() {
        super.init()
        bindingData()
    }
    func bindingData(){
        self.searchInput.asObservable().subscribe(onNext: { [weak self] (text) in
            if !text.isEmpty{
                self?.getResultPlacesBySearch(keyword: text)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    private func getResultPlacesBySearch(keyword: String){
        GoogleMapApi.shared.getListAddresBySearch(keyword: keyword) {[weak self] (_listPlaces) in
            guard let strongSelf = self, let listPlaces = _listPlaces else {return}
            print("text: \(keyword)")
            print(listPlaces.count)
            strongSelf.searchResult.accept(listPlaces)
        }
    }
}

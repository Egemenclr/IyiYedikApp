//
//  CategoryListViewModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.01.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct CategoryListViewInput {
    let indexSelected: Observable<IndexPath>
}

struct CategoryListViewOutput {
    let dataSource: Observable<[SectionModel<String, String>]>
    let selectedCategory: Driver<String>
}

final class CategoryListViewModel {
    let recentList = BehaviorRelay<[String]>.just(["süt","soda","yogurt",
                                                   "cips","ayran"])
    let popularList = BehaviorRelay<[String]>.just(["su","süt","ekmek","soda","cips","yoğurt",
                                                    "yumurta","kola","noodle","ayran"])
    
    init(_ inputs: CategoryListViewInput) {
        
    }
    
    func outputs(_ inputs: CategoryListViewInput) -> CategoryListViewOutput {
        return CategoryListViewOutput(
            dataSource: getDatasource(),
            selectedCategory: selectedIndex(inputs, recentList)
        )
    }
}

func getDatasource()
-> Observable<[SectionModel<String, String>]> {
    Observable.just([
        SectionModel(
            model: "first",
            items: ["süt", "soda", "yogurt", "cips", "ayran"]
        ),
        SectionModel(
            model: "second",
            items: ["su","süt","ekmek","soda","cips","yoğurt","yumurta","kola","noodle","ayran"]
        )
    ])
}

func selectedIndex(
    _ inputs: CategoryListViewInput,
    _ categoryList: Observable<[String]> )
-> Driver<String> {
    inputs.indexSelected
        .observe(on: MainScheduler.asyncInstance)
        .withLatestFrom(getDatasource()) { ($0, $1) }
        .map { (indexPath, model) in
            model[indexPath.section].items[indexPath.item]
        }
        .asDriver(onErrorDriveWith: .never())
}

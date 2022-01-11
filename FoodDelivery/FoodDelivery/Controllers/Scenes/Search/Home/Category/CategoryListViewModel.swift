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
    
}

struct CategoryListViewOutput {
    let dataSource: Observable<[SectionModel<String, String>]>
}

final class CategoryListViewModel {
    
    init(_ inputs: CategoryListViewInput) {
        
    }
    
    func outputs() -> CategoryListViewOutput {
        return CategoryListViewOutput(
            dataSource: getDatasource()
        )
    }
}

func getDatasource() -> Observable<[SectionModel<String, String>]>{
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

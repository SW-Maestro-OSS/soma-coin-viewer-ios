//
//  SampleViewController.swift
//  ProjectDescriptionHelpers
//
//

import UIKit
import Combine

import DomainInterface
import CoreUtil

public class SampleViewController: UIViewController {
    
    @Injected var repo: AllMarketTickerRepository
    
    var bag: Set<AnyCancellable> = .init()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        repo
            .subscribeToStream()
            .sink { list in
                print(list)
            }
            .store(in: &bag)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) { [repo] in
            
            repo.unsubscribeFromStream()
        }
    }
}

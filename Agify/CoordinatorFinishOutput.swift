//
//  CoordinatorFinishOutput.swift
//  Agify
//
//  Created by Dr.Alexandr on 04.11.2022.
//

import Foundation

protocol CoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
}

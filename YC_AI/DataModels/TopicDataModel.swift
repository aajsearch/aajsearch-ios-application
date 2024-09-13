//
//  TopicDataModel.swift
//  YC_AI
//
//  Created by Geeta Manek on 25/08/24.
//

import Foundation
import UIKit

struct TopicModel {
    var id: String // Unique ID for each topic
    var imageName: String
    var title: String
    var description: String
}

struct ChatModel {
    let id: Int
    let agentTitle: String
}

let mockResponses: [String: [String]] = [
    "how to save money": [
        "Start by creating a budget and sticking to it.",
        "Consider setting up a savings account with automatic transfers.",
        "Track your spending and look for areas to cut back."
    ],
    "best ways to invest": [
        "Consider investing in low-cost index funds.",
        "Look into real estate investments.",
        "Diversify your investments to minimize risk."
    ],
    "how to get out of debt": [
        "Create a debt repayment plan and stick to it.",
        "Consider consolidating your debts for easier management.",
        "Cut unnecessary expenses and apply the savings towards your debt."
    ],
    "how to build an emergency fund": [
        "Aim to save 3-6 months' worth of living expenses.",
        "Set up a separate savings account for emergencies.",
        "Contribute a fixed amount regularly to build the fund."
    ],
    "retirement planning tips": [
        "Start saving early to take advantage of compound interest.",
        "Consider contributing to retirement accounts like 401(k) or IRA.",
        "Regularly review and adjust your retirement savings plan."
    ],
    "what is credit score": [
        "A credit score is a numerical representation of your creditworthiness.",
        "It's used by lenders to evaluate your ability to repay loans.",
        "Maintaining a good credit score can help you get better loan terms."
    ]
]

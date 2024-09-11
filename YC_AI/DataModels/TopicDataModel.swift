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
    "hello": [
        "Hi there! How can I help you today?",
        "Hello! What can I do for you?",
        "Hey! How's it going?"
    ],
    "how are you": [
        "I'm just a bunch of code, but I'm doing great! How about you?",
        "I'm here to help you! How can I assist you today?",
        "I'm functioning as expected! What's on your mind?"
    ],
    "what is your name": [
        "I'm your friendly AI assistant!",
        "You can call me ChatBot!",
        "I'm the AI assistant here to help you!"
    ],
    "tell me a joke": [
        "Why don't scientists trust atoms? Because they make up everything!",
        "Why did the scarecrow win an award? Because he was outstanding in his field!",
        "Why don't skeletons fight each other? They don't have the guts!"
    ],
    "what is the weather like": [
        "It's always sunny in the digital world!",
        "I can't check the weather, but I hope it's nice where you are!",
        "Weather is perfect in my virtual space!"
    ],
    "goodbye": [
        "Goodbye! Have a great day!",
        "See you later! Take care!",
        "Bye! Don't hesitate to come back if you have more questions!"
    ]
]

// StartChatDataModel.swift
// YC_AI
//
// Created by Geeta Manek on 14/09/24.
//

import Foundation
import ObjectMapper

// System Communication Model
class SystemCommunicationModel: Mappable {
    var goal: String?
    var classification: String?
    var phase: String?
    var action: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        goal           <- map["Goal"]
        classification <- map["Classification"]
        phase          <- map["Phase"]
        action         <- map["Action"]
    }
}

class ChatResponseModel: Mappable {
    var conversationId: String?
    var agentResponse: String?
    var currentStage: String?
    var stageStatus: String?
    var systemCommunication: SystemCommunicationModel?

    required init?(map: Map) {}

    func mapping(map: Map) {
        conversationId       <- map["conversation_id"]
        agentResponse        <- map["agent_response"]
        currentStage         <- map["current_stage"]
        stageStatus          <- map["stage_status"]
        systemCommunication  <- map["system_communication"]
    }
}

class ContinueChatModel: Mappable {
    var conversationId: String?
    var agentResponse: String?
    var currentStage: String?
    var stageStatus: String?
    var nextStage: String?
    var endOfConversation: Bool?
    var systemCommunication: SystemCommunicationModel?

    required init?(map: Map) {}

    func mapping(map: Map) {
        conversationId       <- map["conversation_id"]
        agentResponse        <- map["agent_response"]
        currentStage         <- map["current_stage"]
        stageStatus          <- map["stage_status"]
        nextStage            <- map["next_stage"]
        endOfConversation    <- map["end_of_conversation"]
        systemCommunication  <- map["system_communication"]
    }
}

//
//  StartChatDataModel.swift
//  YC_AI
//
//  Created by Geeta Manek on 14/09/24.
//

import Foundation
import ObjectMapper


class ChatResponseModel: Mappable {
    var conversationId: String?
    var agentResponse: String?
    var currentStage: String?
    var stageStatus: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        conversationId   <- map["conversation_id"]
        agentResponse    <- map["agent_response"]
        currentStage     <- map["current_stage"]
        stageStatus      <- map["stage_status"]
    }
}

class ContinueChatModel: Mappable {
    var conversationId: String?
    var agentResponse: String?
    var currentStage: String?
    var stageStatus: String?
    var nextStage: String?
    var endOfConversation: Bool?

    required init?(map: Map) {}

    func mapping(map: Map) {
        conversationId       <- map["conversation_id"]
        agentResponse        <- map["agent_response"]
        currentStage         <- map["current_stage"]
        stageStatus          <- map["stage_status"]
        nextStage            <- map["next_stage"]
        endOfConversation    <- map["end_of_conversation"]
    }
}

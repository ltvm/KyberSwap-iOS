// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import APIKit
import JSONRPCKit

struct EtherServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch

    typealias Response = Batch.Responses

    var baseURL: URL {
      // Change to KyberNetwork endpoint
      if let customRPC = KNEnvironment.default.customRPC, let path = URL(string: customRPC.endpoint + KNEnvironment.default.nodeEndpoint) {
        return path
      }
      let config = Config()
      return config.rpcURL
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return ""
    }

    var parameters: Any? {
        return batch.requestObject
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}

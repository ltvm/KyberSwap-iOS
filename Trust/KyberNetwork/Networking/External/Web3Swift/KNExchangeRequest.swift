// Copyright SIX DAY LLC. All rights reserved.

import UIKit
import BigInt
import TrustKeystore

//swiftlint:disable line_length
struct KNExchangeRequestEncode: Web3Request {
  typealias Response = String

  static let abi = "{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"}, {\"name\":\"srcAmount\",\"type\":\"uint256\"},{\"name\":\"dest\",\"type\":\"address\"}, {\"name\":\"destAddress\",\"type\":\"address\"},{\"name\":\"maxDestAmount\",\"type\":\"uint256\"},{\"name\":\"minConversionRate\",\"type\":\"uint256\"},{\"name\":\"walletId\",\"type\":\"address\"}],\"name\":\"trade\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"}"

  let exchange: KNDraftExchangeTransaction
  let address: Address

  var type: Web3RequestType {
    let run = "web3.eth.abi.encodeFunctionCall(\(KNExchangeRequestEncode.abi), [\"\(exchange.from.address.description)\", \"\(exchange.amount.description)\", \"\(exchange.to.address.description)\", \"\(address.description)\", \"\(exchange.maxDestAmount.description)\", \"\(exchange.minRate?.description ?? "")\", \"0x0000000000000000000000000000000000000000\"])"
    return .script(command: run)
  }
}

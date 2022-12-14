// Copyright SIX DAY LLC. All rights reserved.

import UIKit

protocol KNTokenChartCoordinatorDelegate: class {
  func tokenChartCoordinator(sell token: TokenObject)
  func tokenChartCoordinator(buy token: TokenObject)
}

class KNTokenChartCoordinator: Coordinator {

  let navigationController: UINavigationController
  let session: KNSession
  let token: TokenObject
  var coordinators: [Coordinator] = []
  var balances: [String: Balance] = [:]

  weak var delegate: KNTokenChartCoordinatorDelegate?

  lazy var rootViewController: KNTokenChartViewController = {
    let viewModel = KNTokenChartViewModel(token: self.token)
    let controller = KNTokenChartViewController(viewModel: viewModel)
    controller.loadViewIfNeeded()
    controller.delegate = self
    return controller
  }()

  fileprivate var sendTokenCoordinator: KNSendTokenViewCoordinator?

  fileprivate var newAlertController: KNNewAlertViewController?

  init(
    navigationController: UINavigationController,
    session: KNSession,
    balances: [String: Balance],
    token: TokenObject
    ) {
    self.navigationController = navigationController
    self.session = session
    self.balances = balances
    self.token = token
  }

  func start() {
    self.navigationController.pushViewController(self.rootViewController, animated: true)
    if let bal = balances[self.token.contract] {
      self.rootViewController.coordinatorUpdateBalance(balance: [self.token.contract: bal])
    }
  }

  func stop() {
    self.navigationController.popViewController(animated: true)
  }

  func coordinatorTokenBalancesDidUpdate(balances: [String: Balance]) {
    balances.forEach { self.balances[$0.key] = $0.value }
    if let bal = balances[self.token.contract] {
      self.rootViewController.coordinatorUpdateBalance(balance: [self.token.contract: bal])
    }
    self.sendTokenCoordinator?.coordinatorTokenBalancesDidUpdate(balances: self.balances)
  }

  func coordinatorExchangeRateDidUpdate() {
    self.rootViewController.coordinatorUpdateRate()
    self.sendTokenCoordinator?.coordinatorDidUpdateTrackerRate()
  }

  func coordinatorTokenObjectListDidUpdate(_ tokenObjects: [TokenObject]) {
    self.sendTokenCoordinator?.coordinatorTokenObjectListDidUpdate(tokenObjects)
  }

  func coordinatorGasPriceCachedDidUpdate() {
    self.sendTokenCoordinator?.coordinatorGasPriceCachedDidUpdate()
  }
}

extension KNTokenChartCoordinator: KNTokenChartViewControllerDelegate {
  func tokenChartViewController(_ controller: KNTokenChartViewController, run event: KNTokenChartViewEvent) {
    switch event {
    case .back:
      self.stop()
    case .buy(let token):
      self.delegate?.tokenChartCoordinator(buy: token)
    case .sell(let token):
      self.delegate?.tokenChartCoordinator(sell: token)
    case .send(let token):
      self.sendTokenCoordinator = KNSendTokenViewCoordinator(
        navigationController: self.navigationController,
        session: self.session,
        balances: self.balances,
        from: token
      )
      self.sendTokenCoordinator?.start()
    case .openEtherscan(let token):
      if let etherScanEndpoint = KNEnvironment.default.knCustomRPC?.etherScanEndpoint, let url = URL(string: "\(etherScanEndpoint)address/\(token.contract)") {
        self.navigationController.openSafari(with: url)
      }
    case .addNewAlert(let token):
      if KNAlertStorage.shared.isMaximumAlertsReached {
        let alertController = UIAlertController(
          title: "Cap reached".toBeLocalised(),
          message: "You can only have maximum of 10 alerts".toBeLocalised(),
          preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", value: "OK", comment: ""), style: .cancel, handler: nil))
        self.navigationController.present(alertController, animated: true, completion: nil)
        return
      }
      if IEOUserStorage.shared.user == nil {
        self.navigationController.showErrorTopBannerMessage(
          with: NSLocalizedString("error", value: "Error", comment: ""),
          message: "You must sign in to use Price Alert feature".toBeLocalised(),
          time: 1.5
        )
        return
      }
      self.newAlertController = KNNewAlertViewController()
      self.newAlertController?.loadViewIfNeeded()
      self.navigationController.pushViewController(self.newAlertController!, animated: true) {
        self.newAlertController?.updatePair(token: token, currencyType: KNAppTracker.getCurrencyType())
      }
    }
  }
}

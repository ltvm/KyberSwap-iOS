// Copyright SIX DAY LLC. All rights reserved.

import UIKit

class KNNotificationMethodsViewController: KNBaseViewController {

  @IBOutlet weak var headerContainerView: UIView!
  @IBOutlet weak var navTitleLabel: UILabel!
  @IBOutlet weak var getAlertByTextLabel: UILabel!
  @IBOutlet weak var pushNotificationTextLabel: UILabel!
  @IBOutlet weak var pushNotiContainerView: UIView!
  @IBOutlet weak var pushNotiButton: UIButton!
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var emailTextLabel: UILabel!
  @IBOutlet weak var emailContainerView: UIView!
  @IBOutlet weak var telegramButton: UIButton!
  @IBOutlet weak var telegramTextLabel: UILabel!
  @IBOutlet weak var telegramContainerView: UIView!

  fileprivate var isPushNotiEnabled: Bool = true
  fileprivate var isEmailEnabled: Bool = true
  fileprivate var isTelegramEnabled: Bool = true

  override func viewDidLoad() {
    super.viewDidLoad()
    self.headerContainerView.applyGradient(with: UIColor.Kyber.headerColors)
    self.navTitleLabel.text = "Alert Method".toBeLocalised()
    self.pushNotificationTextLabel.text = "Push Notification".toBeLocalised()

    let tapPushNoti = UITapGestureRecognizer(target: self, action: #selector(self.pushNotiButtonPressed(_:)))
    self.pushNotiContainerView.addGestureRecognizer(tapPushNoti)
    self.pushNotiContainerView.isUserInteractionEnabled = true

    let tapEmail = UITapGestureRecognizer(target: self, action: #selector(self.emailButtonPressed(_:)))
    self.emailContainerView.addGestureRecognizer(tapEmail)
    self.emailContainerView.isUserInteractionEnabled = true

    let tapTelegram = UITapGestureRecognizer(target: self, action: #selector(self.telegramButtonPressed(_:)))
    self.telegramContainerView.addGestureRecognizer(tapTelegram)
    self.telegramContainerView.isUserInteractionEnabled = true

    self.updateUIs()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if IEOUserStorage.shared.user == nil { self.navigationController?.popViewController(animated: true) }
    self.reloadAlertMethods()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.headerContainerView.removeSublayer(at: 0)
    self.headerContainerView.applyGradient(with: UIColor.Kyber.headerColors)
  }

  fileprivate func reloadAlertMethods() {
    guard let accessToken = IEOUserStorage.shared.user?.accessToken else { return }
    self.displayLoading()
    KNPriceAlertCoordinator.shared.getAlertMethods(accessToken: accessToken) { [weak self] (resp, error) in
      guard let `self` = self else { return }
      self.hideLoading()
      if error == nil {
        self.isPushNotiEnabled = resp["push_notification"] as? Bool ?? false
        self.isEmailEnabled = resp["email"] as? Bool ?? false
        self.isTelegramEnabled = resp["telegram"] as? Bool ?? false
        if resp["push_notification"] == nil {
          self.pushNotiButton.isHidden = true
          self.pushNotificationTextLabel.isHidden = true
          self.pushNotiContainerView.isHidden = true
        } else {
          self.pushNotiButton.isHidden = false
          self.pushNotificationTextLabel.isHidden = false
          self.pushNotiContainerView.isHidden = false
        }
        if resp["email"] == nil {
          self.emailButton.isHidden = true
          self.emailTextLabel.isHidden = true
          self.emailContainerView.isHidden = true
        } else {
          self.emailButton.isHidden = false
          self.emailTextLabel.isHidden = false
          self.emailContainerView.isHidden = false
        }
        if resp["telegram"] == nil {
          self.telegramButton.isHidden = true
          self.telegramTextLabel.isHidden = true
          self.telegramContainerView.isHidden = true
        } else {
          self.telegramButton.isHidden = false
          self.telegramTextLabel.isHidden = false
          self.telegramContainerView.isHidden = false
        }
        self.updateUIs()
      } else {
        self.showAlertCanNotLoadAlertMethods()
      }
    }
  }

  fileprivate func showAlertCanNotLoadAlertMethods() {
    let alert = UIAlertController(
      title: NSLocalizedString("error", value: "Error", comment: ""),
      message: "Can not load alert methods. Please try again".toBeLocalised(),
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: NSLocalizedString("reload", value: "Reload", comment: ""), style: .default, handler: { _ in
      self.reloadAlertMethods()
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", value: "Cancel", comment: ""), style: .cancel, handler: { _ in
      self.navigationController?.popViewController(animated: true)
    }))
    self.present(alert, animated: true, completion: nil)
  }

  fileprivate func updateUIs() {
    if self.isPushNotiEnabled {
      self.pushNotiButton.setImage(UIImage(named: "check_box_icon"), for: .normal)
      self.pushNotiButton.rounded(color: UIColor.clear, width: 1.0, radius: 4.0)
    } else {
      self.pushNotiButton.setImage(nil, for: .normal)
      self.pushNotiButton.rounded(color: UIColor.Kyber.border, width: 1.0, radius: 4.0)
    }
    if self.isEmailEnabled {
      self.emailButton.setImage(UIImage(named: "check_box_icon"), for: .normal)
      self.emailButton.rounded(color: UIColor.clear, width: 1.0, radius: 4.0)
    } else {
      self.emailButton.setImage(nil, for: .normal)
      self.emailButton.rounded(color: UIColor.Kyber.border, width: 1.0, radius: 4.0)
    }
    if self.isTelegramEnabled {
      self.telegramButton.setImage(UIImage(named: "check_box_icon"), for: .normal)
      self.telegramButton.rounded(color: UIColor.clear, width: 1.0, radius: 4.0)
    } else {
      self.telegramButton.setImage(nil, for: .normal)
      self.telegramButton.rounded(color: UIColor.Kyber.border, width: 1.0, radius: 4.0)
    }
  }

  @IBAction func pushNotiButtonPressed(_ sender: Any) {
    self.isPushNotiEnabled = !self.isPushNotiEnabled
    self.updateUIs()
  }

  @IBAction func emailButtonPressed(_ sender: Any) {
    self.isEmailEnabled = !self.isEmailEnabled
    self.updateUIs()
  }

  @IBAction func telegramButtonPressed(_ sender: Any) {
    self.isTelegramEnabled = !self.isTelegramEnabled
    self.updateUIs()
  }

  @IBAction func saveButtonPressed(_ sender: Any) {
    guard let accessToken = IEOUserStorage.shared.user?.accessToken else { return }
    self.displayLoading(text: "Updating".toBeLocalised(), animated: true)
    KNPriceAlertCoordinator.shared.updateAlertMethods(accessToken: accessToken, email: self.isEmailEnabled, telegram: self.isTelegramEnabled, pushNoti: self.isPushNotiEnabled) { [weak self] (_, error) in
      guard let `self` = self else { return }
      self.hideLoading()
      if error == nil {
        self.showSuccessTopBannerMessage(
          with: NSLocalizedString("success", value: "Success", comment: ""),
          message: "Updated alert methods successfully!".toBeLocalised(),
          time: 1.5
        )
      } else {
        self.showSuccessTopBannerMessage(
          with: NSLocalizedString("error", value: "Error", comment: ""),
          message: "Can not update alert methods!".toBeLocalised(),
          time: 1.5
        )
      }
    }
  }

  @IBAction func backButtonPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func screenEdgePanAction(_ sender: UIScreenEdgePanGestureRecognizer) {
    self.navigationController?.popViewController(animated: true)
  }
}

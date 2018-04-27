// Copyright SIX DAY LLC. All rights reserved.

import UIKit
import SwiftMessages

extension NSObject {
  func showWarningTopBannerMessage(with title: String = "", message: String = "") {
    self.showTopBannerView(with: title, message: message, theme: .warning)
  }

  func showSuccessTopBannerMessage(with title: String = "", message: String = "") {
    self.showTopBannerView(with: title, message: message, theme: .success)
  }

  func showErrorTopBannerMessage(with title: String = "", message: String = "") {
    self.showTopBannerView(with: title, message: message, theme: .error)
  }

  func showTopBannerView(with title: String = "", message: String = "", theme: Theme, layout: MessageView.Layout = .cardView) {
    let view: MessageView = {
      let view = MessageView.viewFromNib(layout: layout)
      view.configureTheme(theme)
      view.configureDropShadow()
      view.button?.isHidden = true
      if theme == .success {
        let iconText = ["😁", "😄", "😆", "😉", "😎", "😍"].sm_random()!
        view.configureContent(title: title, body: message, iconText: iconText)
      } else {
        let iconText = ["🤔", "😳", "🙄", "😶", "😰", "😢", "😥"].sm_random()!
        view.configureContent(title: title, body: message, iconText: iconText)
      }
      return view
    }()
    let config: SwiftMessages.Config = {
      var config = SwiftMessages.Config()
      config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
      config.duration = .seconds(seconds: 1.5)
      config.dimMode = .gray(interactive: true)
      config.interactiveHide = true
      config.preferredStatusBarStyle = .lightContent
      return config
    }()
    SwiftMessages.show(config: config, view: view)
  }
}
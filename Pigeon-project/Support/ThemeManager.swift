//
//  ThemeManager.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//



import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme: Int {
  case Default, Dark
  
  var generalBackgroundColor: UIColor {
    switch self {
    case .Default:
      return UIColor.white
    case .Dark:
      return UIColor.black
    }
  }
  
  var generalTitleColor: UIColor {
    switch self {
    case .Default:
      return UIColor.black
    case .Dark:
      return UIColor.white
    }
  }
  
  var generalSubtitleColor: UIColor {
    switch self {
    case .Default:
      return UIColor.lightGray
    case .Dark:
      return UIColor.lightGray
    }
  }
  
  var inputTextViewColor: UIColor {
    switch self {
    case .Default:
      return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    case .Dark:
      return UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
    }
  }
  
  var mediaPickerControllerBackgroundColor: UIColor {
    switch self {
    case .Default:
      return UIColor(red: 209.0/255.0, green: 213.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    case .Dark:
      return UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
    }
  }
  
  var splashImage: UIImage {
    switch self {
    case .Default:
      return UIImage(named: "whiteSplash")!
    case .Dark:
      return UIImage(named: "blackSplash")!
    }
  }
  
  var typingIndicatorURL: URL? {
    switch self {
    case .Default:
      return Bundle.main.url(forResource: "typingIndicator", withExtension: "gif")
    case .Dark:
      return Bundle.main.url(forResource: "typingindicatorDark", withExtension: "gif")
    }
  }
  
  var enterPhoneNumberBackground: UIImage {
    switch self {
    case .Default:
      return  UIImage(named: "PigeonAuthCountryButton")!
    case .Dark:
      return UIImage(named: "DarkPigeonAuthCountryButton")!
    }
  }
  
  var enterPhoneNumberBackgroundSelected: UIImage {
    switch self {
    case .Default:
      return UIImage(named:"PigeonAuthCountryButtonHighlighted")!
    case .Dark:
      return UIImage(named:"DarkPigeonAuthCountryButtonHighlighted")!
    }
  }
  
  

  
  var incomingBubble: UIImage {
    switch self {
    case .Default:
      return  UIImage(named: "DarkPigeonBubbleIncomingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 22, 17, 20))//UIImage(named: "PigeonBubbleIncomingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 22, 17, 20))
    case .Dark:
      return UIImage(named: "DarkPigeonBubbleIncomingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 22, 17, 20))
    }
  }
  
  var outgoingBubble: UIImage {
    switch self {
    case .Default:
      return UIImage(named: "PigeonBubbleOutgoingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 14, 17, 28))
    case .Dark: //DarkPigeonBubbleOutgoingFull
      return UIImage(named: "PigeonBubbleOutgoingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 14, 17, 28))
    }
  }
  
  var keyboardAppearance: UIKeyboardAppearance {
    switch self {
    case .Default:
      return  .default
    case .Dark:
      return .dark
    }
  }

  var barStyle: UIBarStyle {
    switch self {
    case .Default:
      return .default
    case .Dark:
      return .black
    }
  }
  
  var statusBarStyle: UIStatusBarStyle {
    switch self {
    case .Default:
      return .default
    case .Dark:
      return .lightContent
    }
  }
  
  var scrollBarStyle: UIScrollViewIndicatorStyle {
    switch self {
    case .Default:
      return .default
    case .Dark:
      return .white
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .Default:
      return UIColor.white
    case .Dark:
      return UIColor.black
    }
  }
  
  var secondaryColor: UIColor {
    switch self {
    case .Default:
      return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    case .Dark:
      return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
  
    }
  }
}


func setGlobalNavigationBarSettingsAccordingToTheme(theme: Theme) {
  
//  if #available(iOS 11.0, *) {
//    UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:  theme.generalTitleColor ]
//  } else {
//    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.generalTitleColor]
//  }

  UITabBar.appearance().barStyle = theme.barStyle
  UINavigationBar.appearance().isTranslucent = false
  UINavigationBar.appearance().barStyle = theme .barStyle
  UIApplication.shared.statusBarStyle = theme.statusBarStyle
  UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: theme.generalTitleColor]
}


struct ThemeManager {
  
  static func applyTheme(theme: Theme) {
    UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
    UserDefaults.standard.synchronize()
    setGlobalNavigationBarSettingsAccordingToTheme(theme: theme)
  }
  
  static func currentTheme() -> Theme {
    if let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? Theme.RawValue {
      return Theme(rawValue: storedTheme)!
    } else {
      return .Default
    }
  }
}


struct FalconPalette {
  static let falconPaletteBlue = UIColor(red:0.00, green:0.50, blue:1.00, alpha: 1.0)
}

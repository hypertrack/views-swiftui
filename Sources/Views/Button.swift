import SwiftUI

// MARK: - PrimaryButton

private struct PrimaryButtonStyle: ButtonStyle {
  private let variant: PrimaryButton.Variant
  
  private let gradientGreen = LinearGradient(
    gradient: Gradient(colors: [.malachite, .mountainMeadow]),
    startPoint: .leading,
    endPoint: .trailing
  )
  private let gradientRed = LinearGradient(
    gradient: Gradient(colors: [.darkPink, .radicalRed]),
    startPoint: .leading,
    endPoint: .trailing
  )
  
  init(variant: PrimaryButton.Variant) {
    self.variant = variant
  }
  
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(height: 48)
      .font(.bigBold)
      .foregroundColor(Color.white)
      .background(self.backgroundForVariant(self.variant, isPressed: configuration.isPressed))
      .cornerRadius(24)
  }
  
  func backgroundForVariant(_ variant: PrimaryButton.Variant, isPressed: Bool) -> some View {
    switch variant {
    case .normal:
      if isPressed {
        return ZStack {
          self.gradientGreen
          Color.clear
        }
      } else {
        return ZStack {
          self.gradientGreen
          Color.black.opacity(0.16)
        }
      }
    case .destructive:
      if isPressed {
        return ZStack {
          self.gradientRed
          Color(UIColor.clear)
        }
      } else {
        return ZStack {
          self.gradientRed
          Color.black.opacity(0.16)
        }
      }
    case .disabled:
      return ZStack {
        LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .leading, endPoint: .trailing)
        Color.greySuit.opacity(0.16)
      }
    }
  }
}

private struct ButtonActivityIndicator: UIViewRepresentable {
  let style: UIActivityIndicatorView.Style
  let color: UIColor
  let animating: Bool
  
  init(style: UIActivityIndicatorView.Style = .medium,
       color: UIColor = .white,
       animating: Bool
  ) {
    self.style = style
    self.color = color
    self.animating = animating
  }
  
  func makeUIView(context: UIViewRepresentableContext<ButtonActivityIndicator>) -> UIActivityIndicatorView {
    let activity = UIActivityIndicatorView(style: style)
    activity.hidesWhenStopped = true
    activity.color = color
    return activity
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ButtonActivityIndicator>) {
    if animating {
      uiView.startAnimating()
    } else {
      uiView.stopAnimating()
    }
  }
}

public struct PrimaryButton: View {
  private let variant: Variant
  private let showActivityIndicator: Bool
  private let onTapAction: () -> Void
  
  public enum Variant {
    case normal(title: String)
    case destructive(title: String = "Cancel")
    case disabled(title: String)
    
    var title: String {
      switch self {
      case let .normal(title): return title
      case let .destructive(title): return title
      case let .disabled(title): return title
      }
    }
    
    var isDisabled: Bool {
      if case .disabled = self {
        return true
      } else {
        return false
      }
    }
  }
  
  public init(
    variant: Variant,
    showActivityIndicator: Bool = false,
    _ onTapAction: @escaping () -> Void
  ) {
    self.variant = variant
    self.showActivityIndicator = showActivityIndicator
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    Button(action: onTapAction) {
      HStack {
        Spacer()
        Text(self.variant.title)
          .padding([.leading, .trailing], self.showActivityIndicator ? 0 : 20)
        if self.showActivityIndicator {
          ButtonActivityIndicator(animating: true)
        }
        Spacer()
      }
    }
    .buttonStyle(PrimaryButtonStyle(variant: self.variant))
    .disabled(self.variant.isDisabled)
  }
}

struct PrimaryButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PrimaryButton(variant: .normal(title: "Normal Light"), { })
        .previewScheme(.light)
      PrimaryButton(variant: .normal(title: "Normal Dark"), { })
        .previewScheme(.dark)
      PrimaryButton(variant: .destructive(title: "Destructive Light"), showActivityIndicator: false, {})
        .previewScheme(.light)
      PrimaryButton(variant: .destructive(title: "Destructive Dark"), showActivityIndicator: false, {})
        .previewScheme(.dark)
      PrimaryButton(variant: .disabled(title: "Disabled Light"), showActivityIndicator: false, {})
        .previewScheme(.light)
      PrimaryButton(variant: .disabled(title: "Disabled Dark"), showActivityIndicator: false, {})
        .previewScheme(.dark)
    }
    
    .frame(width: 300, height: 100)
    .previewLayout(.sizeThatFits)
  }
}

// MARK: - SecondaryButton

private struct SecondaryButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme
  
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(height: 48)
      .font(.bigBold)
      .foregroundColor(colorScheme == .dark ? .ghost : .topaz)
  }
}

public struct SecondaryButton: View {
  @Environment(\.colorScheme) var colorScheme
  private let title: String
  private let onTapAction: () -> Void
  
  public init(title: String, _ onTapAction: @escaping () -> Void) {
    self.title = title
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    Button(action: onTapAction) {
      HStack {
        Spacer()
        Text(title)
        Spacer()
      }
    }
    .buttonStyle(
      SecondaryButtonStyle(colorScheme: self._colorScheme)
    )
  }
}

struct SecondaryButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SecondaryButton(title: "Light", { })
        .previewScheme(.light)
      SecondaryButton(title: "Dark", { })
        .previewScheme(.dark)
    }
    .frame(width: 300, height: 100)
    .previewLayout(.sizeThatFits)
  }
}


// MARK: - TransparentButton

private struct TransparentButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme
  
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(height: 48)
      .font(.bigBold)
      .foregroundColor(.malachite)
      .background(
        RoundedRectangle(cornerRadius: 40)
          .fill(colorScheme == .dark ? Color.clear : .cosmicLatte)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .stroke(colorScheme == .dark ? Color.malachite : .clear, lineWidth: 1)
      )
  }
}

public struct TransparentButton: View {
  @Environment(\.colorScheme) var colorScheme
  private let title: String
  private let onTapAction: () -> Void
  
  public init(title: String, _ onTapAction: @escaping () -> Void) {
    self.title = title
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    Button(action: onTapAction) {
      HStack {
        Spacer()
        Text(title)
        Spacer()
      }
    }
    .buttonStyle(
      TransparentButtonStyle(colorScheme: self._colorScheme)
    )
  }
}

struct TransparentButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TransparentButton(title: "Light", { })
        .previewScheme(.light)
      TransparentButton(title: "Dark", { })
        .previewScheme(.dark)
    }
    .frame(width: 300, height: 100)
    .previewLayout(.sizeThatFits)
  }
}

// MARK: - LinkButton

struct LinkButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme
  
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(height: 48)
      .font(.normalMedium)
      .foregroundColor(.dodgerBlue)
  }
}

public struct LinkButton: View {
  @Environment(\.colorScheme) var colorScheme
  private let title: String
  private let onTapAction: () -> Void
  
  public init(title: String, _ onTapAction: @escaping () -> Void) {
    self.title = title
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    Button(action: onTapAction) {
      HStack {
        Spacer()
        Text(title)
        Spacer()
      }
    }
    .buttonStyle(
      LinkButtonStyle(colorScheme: self._colorScheme)
    )
  }
}

struct LinkButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LinkButton(title: "Link light", { })
        .previewScheme(.light)
      LinkButton(title: "Link dark", { })
        .previewScheme(.dark)
    }
    .frame(width: 300, height: 100)
    .previewLayout(.sizeThatFits)
  }
}

// MARK: - NavigationRefreshButton

public struct RefreshButton: View {
  public enum State {
    case disabled, enabled, refreshing
  }
  
  @Environment(\.colorScheme) var colorScheme
  private let state: State
  private let onTapAction: () -> Void
  
  public init(state: State, _ onTapAction: @escaping () -> Void) {
    self.state = state
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    Button(action: onTapAction) {
      if self.state == .refreshing {
        ButtonActivityIndicator(color: self.colorScheme == .light ? UIColor.black : .white, animating: true)
      } else {
        RefreshIcon()
          .frame(width: 28, height: 28)
          .opacity(self.state == .disabled ? 0.5 : 1.0)
      }
    }
    .disabled(self.state != .enabled)
  }
}

struct RefreshButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RefreshButton(state: .disabled, { })
        .previewScheme(.light)
        .previewDisplayName("Disabled Light")
      RefreshButton(state: .disabled, { })
        .previewScheme(.dark)
        .previewDisplayName("Disabled Dark")
      RefreshButton(state: .enabled, { })
        .previewScheme(.light)
        .previewDisplayName("Enabled Light")
      RefreshButton(state: .enabled, { })
        .previewScheme(.dark)
        .previewDisplayName("Enabled Dark")
      RefreshButton(state: .refreshing, { })
        .previewScheme(.light)
        .previewDisplayName("Refreshing Light")
      RefreshButton(state: .refreshing, { })
        .previewScheme(.dark)
        .previewDisplayName("Refreshing Dark")
    }
    .frame(width: 50, height: 50)
    .previewLayout(.sizeThatFits)
  }
}

// MARK: - NavigationBackButton

public struct BackButton: View {
  @Environment(\.colorScheme) var colorScheme
  private let onTapAction: () -> Void
  
  public init(_ onTapAction: @escaping () -> Void) {
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    Button(action: onTapAction) {
      BackIcon().frame(width: 15, height: 21)
    }
  }
}

struct BackButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      BackButton {}
        .previewScheme(.light)
      BackButton {}
        .previewScheme(.dark)
    }
    .frame(width: 50, height: 50)
    .previewLayout(.sizeThatFits)
  }
}

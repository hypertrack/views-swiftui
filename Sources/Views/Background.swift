import SwiftUI

extension View {
  @inlinable public func appBackground() -> some View {
    self.modifier(AppBackground())
  }
}

public struct AppBackground: ViewModifier {
  @Environment(\.colorScheme) var colorScheme
  
  public init() { }
  
  public func body(content: Content) -> some View {
    return content.background(colorScheme == .dark ? Color.haiti : .white)
  }
}

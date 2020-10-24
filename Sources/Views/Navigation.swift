import SwiftUI

// MARK: - Navigation

public struct Navigation<Leading: View, Trailing: View, Content: View>: View {
  @Environment(\.colorScheme) var colorScheme
  private let title: String
  private let leading: () -> Leading
  private let trailing: () -> Trailing
  private let content: () -> Content
  
  public init(
    title: String,
    @ViewBuilder leading: @escaping () -> Leading,
    @ViewBuilder trailing: @escaping () -> Trailing,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.leading = leading
    self.trailing = trailing
    self.content = content
  }
  
  public var body: some View {
    ZStack {
      self.nagivationView.zIndex(1)
      self.content().zIndex(0)
    }
  }
  
  private var nagivationView: some View {
    GeometryReader { geometry in
        VStack(spacing: 0) {
          Rectangle()
            .fill(self.colorScheme == .dark ? Color.gunPowder : .white)
            .frame(height: geometry.safeAreaInsets.top > 20.0 ? geometry.safeAreaInsets.top : 20)
          ZStack {
            HStack {
              self.leading()
                .padding(.leading, 16)
              Spacer()
              self.trailing()
                .padding(.trailing, 16)
            }
            .frame(width: geometry.size.width, height: 44)
            .background(self.colorScheme == .dark ? Color.gunPowder : .white)
            Text(self.title)
              .frame(width: geometry.size.width / 1.5, height: 44)
              .font(.bigMedium)
              .foregroundColor(self.colorScheme == .dark ? .white : .black)
          }
          Spacer()
        }
        .clipped()
        .shadow(radius: 5)
        .edgesIgnoringSafeArea(.top)
    }
  }
}

let navigation = {
  Navigation(
    title: "1201 16th St Mall, Denver, CO 80202,",
    leading: {
      Button(action: {}, label: { Text("Back")})
    },
    trailing: {
      Button(action: {}, label: { Text("Done")})
    },
    content: {
      Text("Content")
    }
  )
}

struct NavigationView_Previews: PreviewProvider {
  
  
  static var previews: some View {
    Group {
      navigation()
      .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
      .environment(\.colorScheme, .light)
      navigation()
        .previewDevice(PreviewDevice(rawValue: "iPhone X"))
        .environment(\.colorScheme, .light)
    }
  }
}

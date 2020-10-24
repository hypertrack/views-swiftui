import SwiftUI

// MARK: - DeliveryCell

public struct DeliveryCell: View {
  @Environment(\.colorScheme) var colorScheme
  private let title: String
  private let subTitle: String
  private let onTapAction: () -> Void
  
  public init(title: String, subTitle: String = "", _ onTapAction: @escaping () -> Void = {}) {
    self.title = title
    self.subTitle = subTitle
    self.onTapAction = onTapAction
  }
  
  public var body: some View {
    GeometryReader { geometry in
      Button(action: {
        self.onTapAction()
      }, label: {
        HStack {
          VStack(alignment: .leading) {
            Text(self.title)
              .font(.normalHighBold)
              .foregroundColor(self.colorScheme == .dark ? .white : .gunPowder)
            if self.subTitle.isEmpty == false {
              Text(self.subTitle)
                .font(.tinyMedium)
                .foregroundColor(self.colorScheme == .dark ? .titanWhite : .greySuit)
                .padding(.top, 4)
            }
          }
          Spacer()
          Image(systemName: "chevron.right").foregroundColor(self.colorScheme == .dark ? .white : .gunPowder)
        }
        .frame(width: geometry.size.width)
      })
    }.frame(height: 50)
  }
}

struct DeliveryCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DeliveryCell(title: "address", subTitle: "subtitle")
        .previewScheme(.light)
      DeliveryCell(title: "address", subTitle: "subtitle")
        .previewScheme(.dark)
    }
    .previewLayout(.sizeThatFits)
    
  }
}

// MARK: - ContentCell

public struct ContentCell: View {
  @Environment(\.colorScheme) var colorScheme
  private let title: String
  private let subTitle: String
  private let leadingPadding: CGFloat
  private let isCopyButtonEnabled: Bool
  private let onCopyAction: (String) -> Void
  
  public init(
    title: String,
    subTitle: String = "",
    leadingPadding: CGFloat = 50.0,
    isCopyButtonEnabled: Bool = true,
    _ onCopyAction: @escaping (String) -> Void = { _ in }
  ) {
    self.title = title
    self.subTitle = subTitle
    self.leadingPadding = leadingPadding
    self.isCopyButtonEnabled = isCopyButtonEnabled
    self.onCopyAction = onCopyAction
  }
  
  public var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(self.title)
          .font(.normalHighBold)
          .foregroundColor(self.colorScheme == .dark ? .white : .gunPowder)
        if self.subTitle.isEmpty == false {
          Text(self.subTitle)
            .font(.tinyMedium)
            .foregroundColor(self.colorScheme == .dark ? .titanWhite : .greySuit)
            .padding(.top, 4)
        }
      }
      .padding(.leading, self.leadingPadding)
      .padding(.top, 8)
      Spacer()
      if self.isCopyButtonEnabled {
        Button {
          self.onCopyAction(self.subTitle)
        } label: {
          Text("Copy")
            .font(.normalHighBold)
            .foregroundColor(self.colorScheme == .dark ? .white : .gunPowder)
        }
          .padding(.trailing, 16)
      }
    }
  }
}

struct ContentCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentCell(title: "address", subTitle: "501 Twin Peaks Blvd, San Francisco, CA 94114 501 Twin Peaks Blvd, San Francisco, CA 94114 ")
        .previewScheme(.light)
      ContentCell(title: "address", subTitle: "501 Twin Peaks Blvd, San Francisco, CA 94114 501 Twin Peaks Blvd, San Francisco, CA 94114 ")
        .previewScheme(.dark)
    }
    .previewLayout(.sizeThatFits)
  }
}

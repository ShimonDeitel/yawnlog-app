import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                Text("Yawnlog Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.foreground)
                Text("Daily energy curve chart across the week")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.foreground.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                Button {
                    Task { await purchases.purchase() }
                } label: {
                    Text(purchases.product.map { "Unlock for \($0.displayPrice)" } ?? "Unlock Pro")
                        .font(Theme.bodyFont.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("paywallPurchaseButton")
                .padding(.horizontal, 24)

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("paywallRestoreButton")
                .font(Theme.captionFont)
                .foregroundStyle(Theme.foreground.opacity(0.7))

                Button("Not Now") { dismiss() }
                    .accessibilityIdentifier("paywallDismissButton")
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.foreground.opacity(0.5))
                    .padding(.bottom, 16)
            }
        }
    }
}

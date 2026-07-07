import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showPaywall = false
    @State private var showSettings = false
    @State private var draftName: String = ""
    @State private var draftBalance: Double = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading) {
                        Text(item.createdAt, style: .date).font(Theme.bodyFont)
                    }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { store.delete(at: $0) }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Yawnlog")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if store.isAtFreeLimit {
                            showPaywall = true
                        } else {
                            showAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addItemButton")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                addSheet
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView().accessibilityIdentifier("paywallView")
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                    .accessibilityIdentifier("addItemFormBackground")
                    .onTapGesture {
                        hideKeyboard()
                    }
                Form {
                    Section {
                        TextField("Note", text: $draftName)
                        .accessibilityIdentifier("itemNameField")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        _ = store.add(FatigueEntry())
                        draftName = ""
                        draftBalance = 0
                        showAddSheet = false
                    }
                    .accessibilityIdentifier("saveItemButton")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showAddSheet = false }
                        .accessibilityIdentifier("cancelItemButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

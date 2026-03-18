//
//  AppointmentsList.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppointmentsList: View {
    let token: String

    @State private var viewModel: AppointmentsViewModel
    @State private var selectedTab: AppointmentTab = .upcoming

    init(token: String, client: any HTTPClientProtocol = HTTPClient.shared) {
        self.token = token
        _viewModel = State(initialValue: AppointmentsViewModel(client: client))
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum AppointmentTab: String, CaseIterable {
        case upcoming, past

        var label: String {
            switch self {
            case .upcoming: Copy.Appointments.upcoming
            case .past: Copy.Appointments.past
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                tabPicker
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                if viewModel.isLoading {
                    loadingView
                } else {
                    appointmentList
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.primary.ignoresSafeArea())
            .navigationTitle(Copy.Appointments.screenTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Copy.Appointments.newButton) {}
                        .accessibilityLabel(Copy.Appointments.newButtonAccessibility)
                }
            }
        }
        .task {
            await viewModel.loadAppointments(token: token)
        }
    }

    @ViewBuilder
    private var tabPicker: some View {
        if #available(iOS 26, *) {
            glassTabPicker
        } else {
            Picker(String(""), selection: $selectedTab) {
                ForEach(AppointmentTab.allCases, id: \.self) { tab in
                    Text(tab.label).tag(tab)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    @available(iOS 26, *)
    private var glassTabPicker: some View {
        GlassEffectContainer(spacing: 4) {
            HStack(spacing: 4) {
                ForEach(AppointmentTab.allCases, id: \.self) { tab in
                    Button(tab.label) {
                        withAnimation(reduceMotion ? nil : .smooth) {
                            selectedTab = tab
                        }
                    }
                    .font(.subheadline.weight(selectedTab == tab ? .semibold : .regular))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .glassEffect(
                        selectedTab == tab ? .regular.tint(Color.brand.primary).interactive() : .regular.interactive(),
                        in: .capsule
                    )
                    .accessibilityAddTraits(selectedTab == tab ? [.isSelected] : [])
                }
            }
        }
    }

    private var appointmentList: some View {
        let appointments = selectedTab == .upcoming
            ? viewModel.upcomingAppointments
            : viewModel.pastAppointments

        return Group {
            if appointments.isEmpty {
                emptyView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(
                            Array(appointments.enumerated()),
                            id: \.element.id
                        ) { index, appointment in
                            AppointmentCard(
                                appointment: appointment,
                                showJoinButton: selectedTab == .upcoming && index == 0
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
        }
        .animation(reduceMotion ? nil : .easeInOut, value: selectedTab)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "calendar")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(selectedTab == .upcoming ? Copy.Appointments.emptyUpcoming : Copy.Appointments.emptyPast)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Upcoming") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.appointments = [.previewUpcoming1, .previewUpcoming2, .previewUpcoming3]
    return AppointmentsList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

#Preview("Past") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.appointments = [.previewPast1, .previewPast2]
    return AppointmentsList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
        .withSelectedTab(.past)
}

#Preview("Empty — Upcoming") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    return AppointmentsList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

#Preview("Loading") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.isLoading = true
    return AppointmentsList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

// MARK: - Preview Helpers

private extension AppointmentsList {
    func withViewModel(_ vm: AppointmentsViewModel) -> AppointmentsList {
        var copy = self
        copy.viewModel = vm
        return copy
    }

    func withSelectedTab(_ tab: AppointmentTab) -> AppointmentsList {
        var copy = self
        copy.selectedTab = tab
        return copy
    }
}

//
//  AppointmentList.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppointmentList: View {
    let token: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var viewModel: AppointmentsViewModel
    @State private var selectedTab: AppointmentTab = .upcoming
    @State private var isShowingNewAppointment: Bool = false

    init(token: String, client: any HTTPClientProtocol = HTTPClient.shared) {
        self.token = token
        _viewModel = State(initialValue: AppointmentsViewModel(client: client))
    }

    enum AppointmentTab: Int, CaseIterable {
        case upcoming = 0, past = 1

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
                
                switch viewModel.state {
                case .idle, .loading:
                    loadingView
                case .error(let message):
                    errorView(message: message)
                case .loaded:
                    pagedContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.primary.ignoresSafeArea())
            .navigationTitle(Copy.Appointments.screenTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewAppointment = true
                    } label: {
                        Label(Copy.Appointments.newButton, image: "icon-add")
                            .labelStyle(.titleAndIcon)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .accessibilityLabel(Copy.Appointments.newButtonAccessibility)
                }
            }
        }
        .task {
            await viewModel.loadAppointments(token: token)
        }
        .sheet(isPresented: $isShowingNewAppointment) {
            VStack(spacing: Constants.l) {
                Text("New appointment")
                    .font(.title)
                    .bold()
                Text("Nothing here yet!")
                    .presentationDetents([.medium])
            }
        }
    }

    private var tabPicker: some View {
        GeometryReader { geo in
            let tabWidth = geo.size.width / CGFloat(AppointmentTab.allCases.count)
            let underlineX = CGFloat(selectedTab.rawValue) * tabWidth

            ZStack(alignment: .bottomLeading) {
                Divider()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

                HStack(spacing: 0) {
                    ForEach(AppointmentTab.allCases, id: \.self) { tab in
                        let isSelected = selectedTab == tab
                        Button {
                            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                        } label: {
                            Text(tab.label)
                                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                                .foregroundStyle(isSelected ? Color.accentFill.primary : .secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                    }
                }

                Rectangle()
                    .fill(Color.accentFill.primary)
                    .frame(width: tabWidth, height: Constants.xxxs)
                    .offset(x: underlineX)
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: underlineX)
            }
        }
        .frame(height: 44)
    }

    private var pagedContent: some View {
        TabView(selection: $selectedTab) {
            appointmentPage(for: .upcoming).tag(AppointmentTab.upcoming)
            appointmentPage(for: .past).tag(AppointmentTab.past)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    private func appointmentPage(for tab: AppointmentTab) -> some View {
        let appointments = tab == .upcoming
            ? viewModel.upcomingAppointments
            : viewModel.pastAppointments

        return Group {
            if appointments.isEmpty {
                ContentUnavailableView(
                    tab == .upcoming ? Copy.Appointments.emptyUpcoming : Copy.Appointments.emptyPast,
                    image: "icon-calendar"
                )
            } else {
                ScrollView {
                    VStack(spacing: Constants.l) {
                        ForEach(
                            Array(appointments.enumerated()),
                            id: \.element.id
                        ) { index, appointment in
                            AppointmentCard(
                                appointment: appointment,
                                isInProgress: tab == .upcoming && index == 0
                            )
                        }
                    }
                    .padding(.vertical, Constants.xl)
                    .padding(.horizontal, Constants.l)
                }
            }
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
                .accessibilityLabel(Copy.Appointments.loading)
            Spacer()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: Constants.m) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(Copy.Appointments.retryButton) {
                Task { await viewModel.loadAppointments(token: token) }
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentFill.primary)
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Upcoming") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.state = .loaded([.previewUpcoming1, .previewUpcoming2, .previewUpcoming3])
    return AppointmentList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

#Preview("Past") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.state = .loaded([.previewPast1, .previewPast2])
    return AppointmentList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
        .withSelectedTab(.past)
}

#Preview("Empty — Upcoming") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.state = .loaded([])
    return AppointmentList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

#Preview("Loading") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.state = .loading
    return AppointmentList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

#Preview("Error") {
    let vm = AppointmentsViewModel(client: MockHTTPClient())
    vm.state = .error(Copy.Errors.generic)
    return AppointmentList(token: "preview", client: MockHTTPClient())
        .withViewModel(vm)
}

// MARK: - Preview Helpers

private extension AppointmentList {
    func withViewModel(_ vm: AppointmentsViewModel) -> AppointmentList {
        let copy = self
        copy.viewModel = vm
        return copy
    }

    func withSelectedTab(_ tab: AppointmentTab) -> AppointmentList {
        let copy = self
        copy.selectedTab = tab
        return copy
    }
}

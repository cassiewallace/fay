//
//  AppointmentsList.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppointmentsList: View {

    // MARK: - Lifecycle

    init(token: String, previewViewModel: AppointmentsViewModel? = nil) {
        self.token = token
        self.isPreview = previewViewModel != nil
        _viewModel = State(initialValue: previewViewModel ?? AppointmentsViewModel())
    }

    // MARK: - Body

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: AppointmentsViewModel
    @State private var selectedTab: AppointmentTab = .upcoming
    @State private var isShowingNewAppointment = false
    let token: String
    private let isPreview: Bool

    private enum AppointmentTab: Int, CaseIterable {
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
            guard !isPreview else { return }
            await viewModel.loadAppointments(token: token)
        }
        .sheet(isPresented: $isShowingNewAppointment) {
            VStack(spacing: Constants.l) {
                Text(Copy.Appointments.newAppointmentSheetTitle)
                    .font(.title)
                    .bold()
                Text(Copy.Appointments.newAppointmentSheetPlaceholder)
                    .presentationDetents([.medium])
            }
        }
    }

    // MARK: - Private

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
                    .frame(width: tabWidth, height: Constants.xs)
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
                .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    VStack(spacing: Constants.l) {
                        ForEach(appointments, id: \.id) { appointment in
                            AppointmentCard(
                                appointment: appointment,
                                isWithinJoinWindow: appointment.isWithinJoinWindow()
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
                .font(.system(size: Constants.xxxl))
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

#Preview {
    let vm = AppointmentsViewModel()
    vm.state = .loaded([
        Appointment.previewInProgress(), .previewUpcoming1, .previewUpcoming2, .previewUpcoming3,
        .previewPast1, .previewPast2
    ])
    return AppointmentsList(token: "preview", previewViewModel: vm)
}


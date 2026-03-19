//
//  AppointmentsList.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppointmentsList: View {
    
    // MARK: - Enums

    private enum AppointmentTab: Int, CaseIterable {
        case upcoming = 0, past = 1

        var label: String {
            switch self {
            case .upcoming: Copy.Appointments.upcoming
            case .past: Copy.Appointments.past
            }
        }
    }
    
    // MARK: - Properties

    let token: String
    
    // MARK: - Private Properties
    
    private let isPreview: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: AppointmentsViewModel
    @State private var selectedTab: AppointmentTab = .upcoming
    @State private var isShowingNewAppointment = false

    // MARK: - Lifecycle

    init(token: String, previewViewModel: AppointmentsViewModel? = nil) {
        self.token = token
        self.isPreview = previewViewModel != nil
        _viewModel = State(initialValue: previewViewModel ?? AppointmentsViewModel())
    }

    // MARK: - Body

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
                        HStack(spacing: Constants.s) {
                            Image("icon-add")
                            Text(Copy.Appointments.newButton)
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.foreground.primary)
                        .padding(.vertical, Constants.m)
                        .padding(.horizontal, {
                            if #available(iOS 26, *) { Constants.m } else { Constants.l }
                        }())
                        .background {
                            if #unavailable(iOS 26) {
                                RoundedRectangle(cornerRadius: Constants.s)
                                    .strokeBorder(Color.border.default, lineWidth: 1)
                            }
                        }
                    }
                    .accessibilityLabel(Copy.Appointments.newButtonAccessibility)
                }
            }
        }
        .task {
            guard !isPreview else { return }
            await viewModel.loadAppointments(token: token)
        }
        .sheet(isPresented: $isShowingNewAppointment) {
            newAppointmentSheet
        }
    }

    // MARK: - Subviews

    private var tabPicker: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(AppointmentTab.allCases, id: \.self) { tab in
                    let isSelected = selectedTab == tab
                    Button {
                        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 0) {
                            Text(tab.label)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(isSelected ? Color.accentFill.primary : .secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Constants.l)
                            Rectangle()
                                .fill(isSelected ? Color.accentFill.primary : Color.clear)
                                .frame(height: 1)
                                .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: isSelected)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                }
            }
            Divider()
        }
        .background(Color.background.primary)
    }

    private var pagedContent: some View {
        TabView(selection: $selectedTab) {
            appointmentPage(for: .upcoming).tag(AppointmentTab.upcoming)
            appointmentPage(for: .past).tag(AppointmentTab.past)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .clipped()
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
    
    private var newAppointmentSheet: some View {
        VStack(spacing: Constants.l) {
            Text(Copy.Appointments.newAppointmentSheetTitle)
                .font(.title)
                .bold()
            Text(Copy.Appointments.newAppointmentSheetPlaceholder)
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Private Functions

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
    
    // MARK: - Private Functions

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


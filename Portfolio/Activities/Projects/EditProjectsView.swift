//
//  EditProjectsView.swift
//  Portfolio
//
//  Created by Robyn Chau on 18/03/2022.
//

import CoreHaptics
import SwiftUI

struct EditProjectsView: View {
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    @State private var engine = try? CHHapticEngine()

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }

    var body: some View {
        Form {
            Section("Basic settings") {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            Section("Custom project color") {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        colorButton(for: item)
                    }
                }
                .padding(.vertical)
            }
            Section("Project reminders:") {
                Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                    .alert("Oops!", isPresented: $showingNotificationsError) {
                        #if os(iOS)
                        Button("Check settings", action: showAppSettings)
                        #endif

                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("There was a problem. Please check you have notifications enabled")
                    }

                if remindMe {
                    DatePicker(
                        "Reminder time:",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)
                Button("Delete this project", role: .destructive) {
                    showingDeleteConfirm = true
                }
            }
            .navigationTitle("Edit Project")
            .onDisappear(perform: dataController.save)
            .alert("Delete project?", isPresented: $showingDeleteConfirm) {
                Button("Delete", role: .destructive) {
                    delete()
                }
            } message: {
                Text("Are you sure you want to delete this project? You will also delete all the items it contains.")
            }
        }
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if remindMe {
            project.reminderTime = reminderTime
            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false
                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func toggleClosed() {
        project.closed.toggle()

        if project.closed {
            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )

                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try engine?.makePlayer(with: pattern)
                try player? .start(atTime: 0)

            } catch {

            }
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : [.isButton]
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    #if os(iOS)
    func showAppSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
    #endif
}

struct EditProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        EditProjectsView(project: Project.example)
            .environmentObject(dataController)

    }
}

import SwiftUI

// MARK: - Draft

struct RouteEntry: Identifiable {
    var id = UUID()
    var name = ""
    var sent = false
    var attempts = "1"
    var grade = ""
}

// MARK: - Extension

extension ManualEntryView {

    // MARK: - Climbing rows

    @ViewBuilder
    var climbingRows: some View {
        let isActive = activeField == .climbType
        Button {
            activeField = .climbType
        } label: {
            HStack(spacing: 16) {
                Text("Type")
                    .foregroundStyle(.secondary)
                    .frame(width: 72, alignment: .leading)
                if climbType.isEmpty {
                    Text("Boulder / Route / Mixed").foregroundStyle(Color.primary.opacity(0.25))
                } else {
                    Text(climbType)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(alignment: .bottom) {
                Rectangle()
                    .fill(isActive ? Color.red : Color.primary.opacity(0.1))
                    .frame(height: isActive ? 2 : 1)
                    .padding(.leading, 104)
            }
        }
        .buttonStyle(.plain)

        ForEach(routes) { route in
            routeListRow(route)
        }

        addRowButton(label: "Add Route") {
            draftRoute = RouteEntry()
            editingRouteId = nil
            activeField = .route(nil)
        }
    }

    // MARK: - Route list row

    private func routeListRow(_ r: RouteEntry) -> some View {
        Button {
            draftRoute = r
            editingRouteId = r.id
            activeField = .route(r.id)
        } label: {
            HStack(spacing: 16) {
                Text(r.name.isEmpty ? "Route" : r.name)
                    .foregroundStyle(r.name.isEmpty ? Color.primary.opacity(0.4) : .primary)
                    .frame(width: 72, alignment: .leading)
                HStack(spacing: 6) {
                    Text(r.sent ? "Sent ✓" : "Attempted")
                        .foregroundStyle(r.sent ? .green : .secondary)
                    if !r.grade.isEmpty {
                        Text("·")
                        Text(r.grade)
                    }
                }
                .font(.subheadline)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(alignment: .bottom) {
                Rectangle().fill(Color.primary.opacity(0.1)).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Route panel

    var routePanel: some View {
        VStack(spacing: 10) {
            suggestionsRow(for: draftRoute.name, pool: suggestions.routeNames) {
                draftRoute.name = $0
            }

            HStack(spacing: 10) {
                TextField("Route / project name", text: $draftRoute.name)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)

                Toggle("", isOn: $draftRoute.sent)
                    .labelsHidden()
                    .tint(.green)
                Text(draftRoute.sent ? "Sent" : "Attempt")
                    .font(.caption)
                    .foregroundStyle(draftRoute.sent ? .green : .secondary)
            }
            .padding(.horizontal, 16)

            HStack(spacing: 10) {
                TextField("Grade (optional)", text: $draftRoute.grade)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)

                numericField("Attempts", text: $draftRoute.attempts)
            }
            .padding(.horizontal, 16)

            commitButton(
                label: editingRouteId == nil ? "Add Route" : "Update",
                disabled: draftRoute.name.isEmpty
            ) {
                commitRoute()
            }
        }
        .padding(.vertical, 10)
    }

    // MARK: - Commit

    private func commitRoute() {
        suggestions.addRoute(draftRoute.name)
        if let id = editingRouteId, let idx = routes.firstIndex(where: { $0.id == id }) {
            routes[idx] = draftRoute
        } else {
            routes.append(draftRoute)
        }
        draftRoute = RouteEntry()
        editingRouteId = nil
        activeField = .route(nil)
    }
}

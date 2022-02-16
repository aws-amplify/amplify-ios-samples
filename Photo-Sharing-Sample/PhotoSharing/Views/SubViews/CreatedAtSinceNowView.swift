//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Amplify

struct CreatedAtSinceNowView: View {

    @State var time: String = ""
    var createdAt: Temporal.DateTime

    var body: some View {
        Text(time)
            .font(.system(size: 12))
            .onAppear {
                self.createdAtSinceNow()
            }
    }

    /// The createdAt of a post shows in two format:
    ///    - A post is created within 24 hours, the time is showed as: 1 second ago, 2 minutes ago, 3 hours ago, etc.
    ///    - Otherwise, it is showed as the exact timestamp, such as 2021-03-14, etc.
    /// `24 * 60 * 60` means  24 hours * 60 minutes * 60 seconds
    func createdAtSinceNow() {
        let now = Temporal.DateTime.now()
        if now.foundationDate.timeIntervalSince(createdAt.foundationDate) <= 24 * 60 * 60 {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            time = formatter.localizedString(for: createdAt.foundationDate,
                                                  relativeTo: now.foundationDate)
        } else {
            time = ISO8601DateFormatter.string(from: createdAt.foundationDate,
                                                    timeZone: .autoupdatingCurrent,
                                                    formatOptions: .withFullDate)
        }
    }
}

struct CreatedAtSinceNowView_Previews: PreviewProvider {
    static var previews: some View {
        /// It is showed as `10 seconds ago`
        let tenSecondsInterval: TimeInterval = -10.0
        let tenSecondsAgo = Temporal.DateTime.init(Date(timeIntervalSinceNow: tenSecondsInterval))
        CreatedAtSinceNowView(createdAt: tenSecondsAgo)

        /// It is showed as `10 minutes ago`
        let tenMinutesInterval: TimeInterval = -10.0 * 60.0
        let tenMinutesAgo = Temporal.DateTime.init(Date(timeIntervalSinceNow: tenMinutesInterval))
        CreatedAtSinceNowView(createdAt: tenMinutesAgo)

        /// It is showed as `10 hours ago`
        let tenHoursInterval: TimeInterval = -10.0 * 60.0 * 60.0
        let tenHoursAgo = Temporal.DateTime.init(Date(timeIntervalSinceNow: tenHoursInterval))
        CreatedAtSinceNowView(createdAt: tenHoursAgo)

        /// The date 10 days before your current date
        /// For example: if you are at `2021-03-16`, then you should be seeing `2021-03-06`
        let tenDaysInterval: TimeInterval = -10.0 * 24.0 * 60.0 * 60.0
        let tenDaysAgo = Temporal.DateTime.init(Date(timeIntervalSinceNow: tenDaysInterval))
        CreatedAtSinceNowView(createdAt: tenDaysAgo)
    }
}

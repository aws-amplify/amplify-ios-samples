//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

enum DataStoreServiceEvent {
    case userSynced(_ user: User)
    case userUpdated(_ user: User)
    case postSynced
    case postCreated(_ post: Post)
    case postDeleted(_ post: Post)
}

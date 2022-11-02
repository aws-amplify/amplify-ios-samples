//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Combine

protocol DataStoreService {
    var user: User? { get }
    var eventsPublisher: AnyPublisher<DataStoreServiceEvent, DataStoreError> { get }

    func configure(_ sessionState: Published<SessionState>.Publisher)
    func savePost(_ post: Post) async throws -> Post
    func deletePost(_ post: Post) async throws
    func saveUser(_ user: User) async throws -> User
    func query<M: Model>(_ model: M.Type,
                         where predicate: QueryPredicate?,
                         sort sortInput: QuerySortInput?,
                         paginate paginationInput: QueryPaginationInput?) async throws -> [M]
    func query<M: Model>(_ model: M.Type,
                         byId: String) async throws -> M?

    func dataStorePublisher<M: Model>(for model: M.Type)
    -> AnyPublisher<AmplifyAsyncThrowingSequence<MutationEvent>.Element, Error>
}

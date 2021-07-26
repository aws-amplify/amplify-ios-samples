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
    func savePost(_ post: Post,
                  completion: @escaping DataStoreCallback<Post>)
    func deletePost(_ post: Post,
                    completion: @escaping DataStoreCallback<Void>)
    func saveUser(_ user: User,
                  completion: @escaping DataStoreCallback<User>)
    func query<M: Model>(_ model: M.Type,
                         where predicate: QueryPredicate?,
                         sort sortInput: QuerySortInput?,
                         paginate paginationInput: QueryPaginationInput?,
                         completion: DataStoreCallback<[M]>)
    func query<M: Model>(_ model: M.Type,
                         byId: String,
                         completion: DataStoreCallback<M?>)
    func dataStorePublisher<M: Model>(for model: M.Type) -> AnyPublisher<MutationEvent, DataStoreError>
}

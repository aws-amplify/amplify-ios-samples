//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import AWSDataStorePlugin
import Foundation
import Combine

class AmplifyDataStoreService: DataStoreService {

    private var authUser: AuthUser?
    private var dataStoreServiceEventsTopic: PassthroughSubject<DataStoreServiceEvent, DataStoreError>

    var user: User?
    var eventsPublisher: AnyPublisher<DataStoreServiceEvent, DataStoreError> {
        return dataStoreServiceEventsTopic.eraseToAnyPublisher()
    }
    private var subscribers = Set<AnyCancellable>()

    init() {
        self.dataStoreServiceEventsTopic = PassthroughSubject<DataStoreServiceEvent, DataStoreError>()
    }

    func configure(_ sessionState: Published<SessionState>.Publisher) {
        listenToDataStoreHubEvents()
        listen(to: sessionState)
    }

    func savePost(_ post: Post) async throws -> Post {
        let savedPost = try await Amplify.DataStore.save(post)
        dataStoreServiceEventsTopic.send(.postCreated(savedPost))
        return savedPost
    }

    func saveUser(_ user: User) async throws -> User {
        let savedUser = try await Amplify.DataStore.save(user)
        dataStoreServiceEventsTopic.send(.userUpdated(savedUser))
        return savedUser
    }

    func query<M: Model>(_ model: M.Type,
                         where predicate: QueryPredicate? = nil,
                         sort sortInput: QuerySortInput? = nil,
                         paginate paginationInput: QueryPaginationInput?) async throws -> [M] {
        return try await Amplify.DataStore.query(model,
                                                 where: predicate,
                                                 sort: sortInput,
                                                 paginate: paginationInput)
    }

    func query<M: Model>(_ model: M.Type,
                         byId id: String) async throws -> M? {
        return try await Amplify.DataStore.query(model, byId: id)
    }

    func deletePost(_ post: Post) async throws {
        try await Amplify.DataStore.delete(post)
        dataStoreServiceEventsTopic.send(.postDeleted(post))
    }

    func dataStorePublisher<M: Model>(for model: M.Type)
    -> AnyPublisher<AmplifyAsyncThrowingSequence<MutationEvent>.Element, Error> {
        Amplify.Publisher.create(Amplify.DataStore.observe(model))
    }

    private func start() {
        Task {
            try await Amplify.DataStore.start()
        }
    }

    private func clear() {
        Task {
            try await Amplify.DataStore.clear()
        }
    }
}

extension AmplifyDataStoreService {
    private func listen(to sessionState: Published<SessionState>.Publisher?) {
        sessionState?
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .signedOut:
                    self.clear()
                    self.user = nil
                    self.authUser = nil
                case .signedIn(let authUser):
                    self.authUser = authUser
                    self.start()
                case .initializing:
                    break
                }
            }
            .store(in: &subscribers)
    }

    private func listenToDataStoreHubEvents() {
        Amplify.Hub.publisher(for: .dataStore)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: hubEventsHandler(payload:))
            .store(in: &subscribers)
    }

    private func hubEventsHandler(payload: HubPayload) {
        switch payload.eventName {
        case HubPayload.EventName.DataStore.modelSynced:
            guard let modelSyncedEvent = payload.data as? ModelSyncedEvent else {
                Amplify.log.error(
                    """
                    Failed to case payload of type '\(type(of: payload.data))' \
                    to ModelSyncedEvent. This should not happen!
                    """
                )
                return
            }
            switch modelSyncedEvent.modelName {
            case User.modelName:
                Task {
                    await getUser()
                }
            case Post.modelName:
                dataStoreServiceEventsTopic.send(.postSynced)
            default:
                return
            }
        default:
            return
        }
    }

    private func getUser() async {
        guard let userId = authUser?.userId else {
            return
        }

        do {
            let user = try await query(User.self, byId: userId)
            guard let user = user else {
                await createUser()
                return
            }
            self.user = user
            dataStoreServiceEventsTopic.send(.userSynced(user))
        } catch {
            Amplify.log.error("Error querying User - \(error.localizedDescription)")
        }
    }

    private func createUser() async {
        guard let authUser = self.authUser else {
            return
        }

        let user = User(id: "\(authUser.userId)",
                        username: authUser.username,
                        profilePic: "emptyUserPic")
        do {
            _ = try await saveUser(user)
            self.user = user
            dataStoreServiceEventsTopic.send(.userSynced(user))
            Amplify.log.debug("Successfully creating User for \(authUser.username)")
        } catch let dataStoreError as DataStoreError {
            self.dataStoreServiceEventsTopic.send(completion: .failure(dataStoreError))
            Amplify.log.error("Error creating User for \(authUser.username) - \(dataStoreError.localizedDescription)")
        } catch {
            Amplify.log.error("Error creating User for \(authUser.username) - \(error.localizedDescription)")
        }

    }
}

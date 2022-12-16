//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Combine
import Foundation

extension UserProfileView {

    class ViewModel: ObservableObject {

        @Published private(set) var user: User?
        @Published private(set) var loadedPosts: [Post] = [Post]()
        @Published private(set) var numberOfMyPosts = 0
        @Published private(set) var isPostSynced = false
        @Published var hasError = false
        @Published var photoSharingError: AmplifyError?

        private var dataStorePublisher: AnyCancellable?
        private var subscribers = Set<AnyCancellable>()

        var dataStoreService: DataStoreService

        init(manager: ServiceManager = AppServiceManager.shared) {
            self.dataStoreService = manager.dataStoreService
            dataStoreService.eventsPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: onReceiveCompletion(completion:),
                      receiveValue: onReceive(event:))
                .store(in: &subscribers)

            manager.errorTopic
                .receive(on: DispatchQueue.main)
                .sink { error in
                    self.photoSharingError = error
                    self.hasError = true
                }
                .store(in: &subscribers)
        }

        private func onReceiveCompletion(completion: Subscribers.Completion<DataStoreError>) {
            if case let .failure(error) = completion {
                self.photoSharingError = PhotoSharingError.model(
                    "Failed to create a User",
                    "Please sign in again",
                    error
                )
                self.hasError = true
            }
        }

        private func onReceive(event: DataStoreServiceEvent) {
            switch event {
            case .userSynced:
                user = dataStoreService.user
                tryLoadPosts()

            case .postSynced:
                dataStorePublisher?.cancel()

                Task {
                    await getNumberOfMyPosts()
                    await fetchMyPosts(page: 0)
                }

                isPostSynced = true
            case .postCreated(let newPost):
                loadedPosts.insert(newPost, at: 0)
                Task {
                    await getNumberOfMyPosts()
                }

            case .postDeleted(let post):
                removePost(post)
                Task {
                    await getNumberOfMyPosts()
                }

            default:
                break
            }
        }

        func fetchMyPosts(page: Int) async {
            guard user != nil else {
                return
            }

            let predicateInput = Post.keys.postedBy == user?.id
            let sortInput = QuerySortInput.descending(Post.keys.createdAt)
            let paginationInput = QueryPaginationInput.page(UInt(page), limit: 10)
            do {
                let posts = try await dataStoreService.query(Post.self,
                                                             where: predicateInput,
                                                             sort: sortInput,
                                                             paginate: paginationInput)
                await MainActor.run {
                    if page != 0 {
                        loadedPosts.append(contentsOf: posts)
                    } else {

                        loadedPosts = posts
                    }

                }
            } catch let error as AmplifyError {
                Amplify.log.error("\(#function) Error loading posts - \(error.localizedDescription)")
                self.photoSharingError = error
                self.hasError = true
            } catch {
                Amplify.log.error("\(#function) Error loading posts - \(error.localizedDescription)")
            }
        }

        private func removePost(_ post: Post) {
            for index in 0 ..< loadedPosts.count {
                guard loadedPosts[index].id == post.id else {
                    continue
                }
                loadedPosts.remove(at: index)
                break
            }
        }

        private func getNumberOfMyPosts() async {
            let predicateInput = Post.keys.postedBy == user?.id
            do {
                let posts = try await dataStoreService.query(Post.self,
                                                             where: predicateInput,
                                                             sort: nil,
                                                             paginate: nil)
                await MainActor.run {
                    self.numberOfMyPosts = posts.count
                }
            } catch let error as AmplifyError {
                Amplify.log.error("\(#function) Error querying number of posts - \(error.localizedDescription)")
                self.photoSharingError = error
                self.hasError = true
            } catch {
                Amplify.log.error("\(#function) Error querying number of posts - \(error.localizedDescription)")
            }

        }

        /// This is called when `dataStoreService` has notified us that the User has been synced.
        /// When App launches, a user performs a sign in:
        ///     The local DB is empty, the first `fetchMyPosts` returns nothing.
        ///     But since the `InitialSync` is kicked off, `dataStorePublishser` keeps receiving `Post` Model,
        ///     a `fetchMyPosts` is triggered either every 10 posts or every 3 seconds which returns posts
        /// When App launches, there is an user signed in:
        ///     The local DB is not empty, the first `fetchMyPosts` returns 10 posts,
        ///     and:
        ///     If `SyncEngine` is doing a `Full Sync`:
        ///         `dataStorePublishser` receives incoming `Post` Model from cloud,
        ///         a `fetchMyPosts` is triggered either every 10 posts or every 3 seconds which returns posts
        ///     if `SyncEngine` is doing a `Delta Sync`:
        ///         the `dataStorePublishser` is not triggered
        /// Finally, `dataStorePublishser` is cancelled when `dataStoreService` notifies us that Post has been synced
        private func tryLoadPosts() {
            guard user != nil else {
                return
            }

            Task {
                await fetchMyPosts(page: 0)
            }

            dataStorePublisher = dataStoreService.dataStorePublisher(for: Post.self)
                .receive(on: DispatchQueue.main)
                .collect(.byTimeOrCount(DispatchQueue.main, 3.0, 10))
                .sink {
                    if case let .failure(error) = $0 {
                        Amplify.log.error("Subscription received error - \(error.localizedDescription)")
                    }
                }
                receiveValue: { [weak self] _ in
                    guard let self = self else {return}
                    Task {
                        await self.fetchMyPosts(page: 0)
                    }
                }
        }

        deinit {
            self.loadedPosts.removeAll()
            self.user = nil
        }
    }
}

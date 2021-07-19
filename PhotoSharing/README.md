# PhotoSharing

PhotoSharing is a demonstration of building an iOS social networking App with [Amplify Libraries](https://docs.amplify.aws/lib/q/platform/ios).

## App features

This app demponstrates the following features:
* Sign Up/Sign In/Sign Out
* Post a photo
* Update your profile image 
* Scroll to view a list of your created posts

### Sign In/Sign Out

The App allows you to sign up and sign in using the [Amplify.Auth.signInWithWebUI](https://docs.amplify.aws/lib/auth/signin_web_ui/q/platform/ios) API.

Sign Up Flow (see [`OnBoardingViewModel`](./PhotoSharing/ViewModels/OnboardingViewModel.swift) for example code):
![Sign Up](./readmeimages/sign-up-flow.png)

Sign In Flow (see [`OnBoardingViewModel`](./PhotoSharing/ViewModels/OnboardingViewModel.swift) for example code):
![Sign In](./readmeimages/sign-in-flow.png)

Sign Out Flow (see [`OnBoardingViewModel`](./PhotoSharing/ViewModels/OnboardingViewModel.swift) for example code):
![Sign Out](./readmeimages/sign-out-flow.png)

### Post Photo

Once you are authenticated, you can create a post with the selected image using the [Amplify.DataStore.save](https://docs.amplify.aws/lib/datastore/data-access/q/platform/ios#create-and-update) and [Amplify.Storage.UploadData](https://docs.amplify.aws/lib/storage/upload/q/platform/ios) APIs.

(see PostEditorViewModel for example code):

![Create Post](./readmeimages/post-creation-flow.png)

### Update profile image

Besides posting image, you can also update your profile image.

(see ConfirmProfileImageViewModel for example code):

![Update Profile](./readmeimages/profile-update-flow.png)

### Posts loading

The loading of the posts is related to [Amplify.DataStore.query](https://docs.amplify.aws/lib/datastore/data-access/q/platform/ios#query-data) and [Amplify.Storage.downloadData](https://docs.amplify.aws/lib/storage/download/q/platform/ios)

![Load Posts](./readmeimages/posts-loading.png)

## Requirements
Before proceeding, please make sure you have followed the [instructions](https://docs.amplify.aws/lib/project-setup/prereq/q/platform/ios) to sign up for an AWS Account and setup the Amplify CLI.

You need to have the following prerequisites to run this project:

* [Xcode 12 or later](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
* [CocoaPods latest version](https://cocoapods.org)
* [Amplify CLI latest version](https://docs.amplify.aws/cli)

Once you have the prerequisites installed, go ahead and clone the repository: 

```bash
git clone git@github.com:aws-amplify/amplify-ios-samples.git
```

## To run it

Navigate to the PhotoSharing directory:
```bash
cd amplify-ios-samples/PhotoSharing
```

### Install dependencies
Download and install required pods into your project:
```bash
pod install --repo-update
```

### Create Backend Resources (amplifyconfiguration.json)

1. Initialize the Amplify project by running the following command:

```
amplify init
```
Press enter at the following prompts to accept the default values.
```
? Enter a name for the project (PhotoSharing)
? Initialize the project with the above configuration? (Y/n)
? Select the authentication method you want to use: (Use arrow keys)
❯ AWS profile 
? Please choose the profile you want to use (Use arrow keys)
❯ default 
```
Wait until provisioning is finished. At this point you have successfully created cloud resources in your AWS account for your app. 

2. Set up Auth configuration

The Amplify Auth category provides an interface for authenticating a user. Behind the scenes, it provides the necessary authorization to the other Amplify categories. It comes with default, built-in support for Amazon Cognito User Pool and Identity Pool.

Add the Amplify Auth category to your project by running the following command:
```
amplify add auth
```
Provide the responses listed after each of the following prompts to configure Auth.
```
? Do you want to use the default authentication and security configuration? `Default configuration with Social Provider (Federation)`
? How do you want users to be able to sign in? `Username`
? Do you want to configure advanced settings? `No, I am done.`
What domain name prefix do you want to use? `(default)`
? Enter your redirect signin URI: `myapp://`
? Do you want to add another redirect signin URI `No`
? Enter your redirect signout URI: `myapp://`
? Do you want to add another redirect signout URI `No`
? Select the social providers you want to configure for your user pool: `Don't select anything, <hit enter> `
```
These commands configured Amplify Auth to authenticate users via a username and password using a pre-built HostedUI endpoint to display sign-up and sign-in interfaces in an embeded web view. After the sign-in process is complete it will redirect back to our app at the URI we specified. This value matches an entry in the app's info.plist that enables it to receive this URI.

For additional information on Amplify Auth: https://docs.amplify.aws/lib/auth/getting-started/q/platform/ios

3. Set up API configuration

The Amplify API category provides an interface for retrieving and persisting your model data. The API category comes with default built-in support for AWS AppSync.

Add the Amplify API category to your project by running the following command:
```
amplify add api
```
Provide the responses listed after each of the following prompts to configure API.
```
? Please select from one of the below mentioned services: `GraphQL`
? Provide API name: `PhotoSharingAPI`
? Choose the default authorization type for the API `Amazon Cognito User Pool`
? Do you want to configure advanced settings for the GraphQL API `Yes, I want to make some additional changes.`
? Configure additional auth types? `No`
? Enable conflict detection? `Yes`
? Select the default resolution strategy `Auto Merge`
? Do you have an annotated GraphQL schema? `yes`
? Provide your schema file path: `schema.graphql`
```
These commands configured Amplify API to provision a GraphQL service with CRUD operations and real-time functionality to start persisting data locally and synchronizing local data to the cloud automatically with DataStore. Authorization is handled via the Cognito User Pool we setup in step 2. The schema for our model is defined in the schema.graphql file.

For additional information on the API category: https://docs.amplify.aws/lib/graphqlapi/getting-started/q/platform/ios

4. Set up Storage configuration

The Amplify Storage category provides an interface for managing user content for your app in public, protected, or private storage buckets. The Storage category comes with default built-in support for Amazon Simple Storage Service (S3).

Add the Amplify Storage category to your project by running the following command:
```
amplify add storage
```
Provide the responses listed after each of the following prompts to configure Storage.
```
? Please select from one of the below mentioned services: `Content (Images, audio, video, etc.)`
? Please provide a friendly name for your resource that will be used to label this category in the project: `S3friendlyName`
? Please provide bucket name: `storagebucketname`
? Who should have access: `Auth users only`
? What kind of access do you want for Authenticated users? `create/update, read, delete`
? Do you want to add a Lambda Trigger for your S3 Bucket? `No`
```
These commandes created and configured an S3 storage bucket named storagebucketname to store photos for the app, specified that only authenticated users can access the bucket, and granted authenticated users the ability to create, update, read, and delete the photos.

For additional information on the Storage category: https://docs.amplify.aws/lib/storage/getting-started/q/platform/ios

5. Now execute the following command to convert the **schema.graphql** into Swift data structures

```
amplify codegen models
```

When finished, a new **AmplifyModels** group is added to your Xcode project.

6. To push your changes to the cloud, execute the following command:

```
amplify push
```
```
? Are you sure you want to continue? `Yes`
? Do you want to generate code for your newly created GraphQL API `No`
```

Upon completion, **amplifyconfiguration.json** should be updated to reference provisioned backend auth, api & storage resources.

### Run the App

You should now be able to open **PhotoSharing.xcworkspace**

And run the App (`Cmd+R`) in your chosen iOS simulator, you should be able to perform the actions that we described on the top.

## Code of Conduct

This project has adopted the [Amazon Open Source Code of Conduct](https://aws.github.io/code-of-conduct).
For more information see the [Code of Conduct FAQ](https://aws.github.io/code-of-conduct-faq) or contact
opensource-codeofconduct@amazon.com with any additional questions or comments.

## Security Issue Notifications

If you discover a potential security issue in this project we ask that you notify AWS/Amazon Security via our
[vulnerability reporting page](http://aws.amazon.com/security/vulnerability-reporting/). Please
do **not** create a public GitHub issue.

## License

This sample app is licensed under the Apache 2.0 License.

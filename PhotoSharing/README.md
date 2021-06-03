# PhotoSharing

PhotoSharing is a demonstration of building an iOS social networking App with [Amplify Libraries](https://docs.amplify.aws/lib/q/platform/ios).

## App features

This is an App that you can perform sign in/sign out, post photos, update your profile image and scroll to view your created posts

### Sign In/Sign Out

The App allows you to sign up, sign in using [Amplify.Auth.signInWithWebUI](https://docs.amplify.aws/lib/auth/signin_web_ui/q/platform/ios) api.

![Sign Up](./readmeimages/sign-up-flow.png)

![Sign In](./readmeimages/sign-in-flow.png)

### Post photos

Once you are authenticated, you can create a post with selected image using [Amplify.DataStore.save](https://docs.amplify.aws/lib/datastore/data-access/q/platform/ios#create-and-update) and [Amplify.Storage.UploadData](https://docs.amplify.aws/lib/storage/upload/q/platform/ios) api

![Create Post](./readmeimages/post-creation-flow.png)

### Update profile image

Besides posting image, you can also update your profile image

![Update Profile](./readmeimages/profile-update-flow.png)

### Posts loading

The loading of the posts is related to [Amplify.DataStore.query](https://docs.amplify.aws/lib/datastore/data-access/q/platform/ios#query-data) and [Amplify.Storage.downloadData](https://docs.amplify.aws/lib/storage/download/q/platform/ios)

![Load Posts](./readmeimages/posts-loading.png)

## Requirements

Before moving forward, please make sure you have followed [intruction](https://docs.amplify.aws/lib/project-setup/prereq/q/platform/ios) to finish signing up AWS Account and setting up Amplify CLI

Once the above step is done, you need to have the following pre-requisites installed on your computer to run this iOS project:

* [Xcode 12 or later](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
* [CocoaPods latest version](https://cocoapods.org)
* [Amplify CLI latest version](https://docs.amplify.aws/cli)

If you have them, then go ahead and clone the repository: 

```bash
git clone git@github.com:aws-amplify/amplify-native-samples-staging.git
```

## To run it

Change directory to PhotoSharing Project:
```bash
cd amplify-native-samples-staging/PhotoSharing/iOS/PhotoSharing
```

### Install dependency
To download and install pod into your project, execute command:
```bash
pod install --repo-update
```

### Create Backend Resources (amplifyconfiguration.json)

1. Initialize Amplify project by running command:

```
amplify init
```
```
? Enter a name for the project: `Enter`
? Enter a name for the environment: `Enter`
? Choose your default editor: `Visual Studio Code`
? Choose the type of App you are building:  `iOS`
? Do you want to use an AWS profile?: `Yes`
? Please choose the profile you want to use: `default`
```
Wait until provisioning is finished

2. Set up Auth configuration
- The following commands will allow user authentication for your users in the App
- Set up a pre-built HostedUI endpoint to display sign up and sign in web view
```
amplify add auth
```
```
? Do you want to use the default authentication and security configuration? `Default configuration with Social Provider (Federation)`
? How do you want users to be able to sign in? `Username`
? Do you want to configure advanced settings? `No, I am done.`
? What domain name prefix you want us to create for you? `(default)`
? Enter your redirect signin URI: `myapp://`
? Do you want to add another redirect signin URI `No`
? Enter your redirect signout URI: `myapp://`
? Do you want to add another redirect signout URI `No`
? Select the social providers you want to configure for your user pool: `<hit enter>`
```

3. Set up API configuration
- The following commands will allow you to start persisting data locally to your device and synchronizing local data to the cloud automatically with DataStore.
```
amplify add api
```
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

4. Set up Storage configuration
- The following commands will allow you to manage(upload/download/remove) image that stored in the S3 bucket.
```
amplify add storage
```
```
? Please select from one of the below mentioned services: `Content (Images, audio, video, etc.)`
? Please provide a friendly name for your resource that will be used to label this category in the project: `S3friendlyName`
? Please provide bucket name: `storagebucketname`
? Who should have access: `Auth users only`
? What kind of access do you want for Authenticated users? `create/update, read, delete`
? Do you want to add a Lambda Trigger for your S3 Bucket? `No`
```

5. To push your changes to the cloud, execute command:

```
amplify push
```
```
? Are you sure you want to continue? `Yes`
? Do you want to generate code for your newly created GraphQL API `No`
```

Upon completion, **amplifyconfiguration.json** should be updated to reference provisioned backend auth, api & storage resources.

5. Now execute the following command to convert the **schema.graphql** into Swift data structures

```
amplify codegen models
```

When finished, a new **AmplifyModels** group is added to your Xcode project.

### Run the App
If you don't have **Xcode Command Line Tools** installed, please follow steps:
1. start Xcode on the Mac
2. Choose **Preferences** from the Xcode menu.
3. In the General panel, click **Downloads**.
4. On the Downloads window, choose the **Components** tab.
5. Click the **Install** button next to **Command Line Tools**.

You should now be able to open **PhotoSharing.xcworkspace** by executing command:
```bash
xed .
```

And run the App (`Cmd+R`) in your chosen iOS simulator, you should be able to perform the actions that we described on the top.

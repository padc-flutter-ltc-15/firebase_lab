
"Add firebase to android and ios as normal way"

"Add firebase dependencies to flutter pubspec.yaml"

"Add the following in main.dart"

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

"Add the following code to Runner\GeneratedPluginRegistrant.m"

//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<firebase_core/FLTFirebaseCorePlugin.h>)
#import <firebase_core/FLTFirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<firebase_database/FLTFirebaseDatabasePlugin.h>)
#import <firebase_database/FLTFirebaseDatabasePlugin.h>
#else
@import firebase_database;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebaseDatabasePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseDatabasePlugin"]];
}

@end

"Add the following code in application() AppDelegate.swift"

FirebaseApp.configure()

"Need to add permission in plist of xcode"

Privacy - Photo ...
Privacy - Camera ...

"FCM"

https://fcm.googleapis.com/fcm/send

{
	"registration_ids": [
		"replace_with_server_key_from_fcm",
		"replace_with_server_key_from_fcm"
	],
	"notification": {
		"title": "Noti Title",
		"body": "Noti Body",
		"priority": "high",
		"content_available": true
	},
	"data": {
		"title": "Noti Title",
		"body": "Noti Body",
		"priority": "high",
		"content_available": true
		"post_id": "..."
	}
}

Ref: https://firebase.google.com/docs/cloud-messaging/http-server-ref
Ref: https://firebase.google.com/docs/cloud-messaging/send-message
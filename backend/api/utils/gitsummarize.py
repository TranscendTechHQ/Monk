

import json
from openai import AzureOpenAI
from config import settings



# Function to call OpenAI API for code summarization
def summarize_code_change(code_diff):
    # Set your Azure-specific OpenAI API key and endpoint
    client = AzureOpenAI(
    api_key = settings.AZURE_OPENAI_KEY,  
    api_version = settings.API_VERSION,
    azure_endpoint =settings.AZURE_OPENAI_ENDPOINT 
    )

    prompt = " What does the following code diff accomplish?\n"
    diff = code_diff[:16000]
    prompt += "```" + diff + "```"
    #prompt = "Summarize the following code change:\n" + code_diff[:16000] + "\nSummary:"
    
    #print(prompt)
    #response =""
    response = client.completions.create(
      model="monk-gpt35",
      prompt=prompt,
      max_tokens=150
    )
    return response.choices[0].text.strip()
    #return response

def json_code_summarization(input_file, output_file):
    # Open the CSV file for reading and writing
    with open(input_file, 'r', newline='') as json_file:
        #read json file
        json_data = json.load(json_file)
        rows = list(json_data)
        
        # Iterate over each row, summarize the code change, and add to the row
        for row in rows:  # Skip the header row
            code_diff = row["code_diff"]  
            #print(code_diff)
            summary = summarize_code_change(code_diff)
            row["code_summary"] = summary
            row["code_diff"] = ""
            
    #Write the updated rows back to the same CSV file
    with open(output_file, 'w', newline='') as json_file:
        json.dump(json_data, json_file, indent=2)

def main():
    prompt = " What does the following code diff accomplish?\n"
    diff = '''
    --- a/frontend/lib/screens/login.dart
+++ b/frontend/lib/screens/login.dart
@@ -1,5 +1,4 @@
-import 'dart:io';
-
+import 'package:flutter/widgets.dart' as prefix;
 import 'package:dio/dio.dart';
 import 'package:flutter/material.dart';
 //import 'package:flutter/services.dart';
@@ -20,27 +19,18 @@ class _LoginScreenState extends State<LoginScreen> {
   Future<void> loginWithGoogle() async {
     GoogleSignIn googleSignIn;
 
-    if (Platform.isAndroid) {
-      googleSignIn = GoogleSignIn(
-        serverClientId: ""GOOGLE_WEB_CLIENT_ID"",
-        scopes: [
-          'email',
-        ],
-      );
-    } else {
-      var googleClientId =
-          ""337392647778-3j84aqtmia13h4rnn76ud66q2aacjr56.apps.googleusercontent.com"";
-      var backendClientId =
-          ""337392647778-99gj0cpsu12dci6uo45f7aue0j7j9rsq.apps.googleusercontent.com"";
+    var googleClientId =
+        ""337392647778-3j84aqtmia13h4rnn76ud66q2aacjr56.apps.googleusercontent.com"";
+    var backendClientId =
+        ""337392647778-99gj0cpsu12dci6uo45f7aue0j7j9rsq.apps.googleusercontent.com"";
 
-      googleSignIn = GoogleSignIn(
-        clientId: googleClientId,
-        serverClientId: backendClientId,
-        scopes: [
-          'email',
-        ],
-      );
-    }
+    googleSignIn = GoogleSignIn(
+      clientId: googleClientId,
+      serverClientId: backendClientId,
+      scopes: [
+        'email',
+      ],
+    );
 
     if (googleSignIn.currentUser != null) {
       // This cleans up the current user from the google sign in package if there is any active user
@@ -77,7 +67,9 @@ class _LoginScreenState extends State<LoginScreen> {
 
       if (result.statusCode == 200) {
         Future.delayed(Duration.zero, () {
-          Navigator.of(context).pushReplacementNamed(""/home"");
+          // ...
+
+          prefix.Navigator.of(context).pushReplacementNamed(""/home"");
         });
       }
     } on DioExceptionType {
diff --git a/frontend/macos/Podfile.lock b/frontend/macos/Podfile.lock
index 548a9d6..7269b5a 100644
--- a/frontend/macos/Podfile.lock
+++ b/frontend/macos/Podfile.lock
@@ -58,7 +58,7 @@ SPEC CHECKSUMS:
   emoji_picker_flutter: 533634326b1c5de9a181ba14b9758e6dfe967a20
   flutter_appauth: b91dffc2477d9b24a32983ca523a91812f228552
   FlutterMacOS: 8f6f14fa908a6fb3fba0cd85dbd81ec4b251fb24
-  google_sign_in_ios: 1bfaf6607b44cd1b24c4d4bc39719870440f9ce1
+  google_sign_in_ios: 989eea5abe94af62050782714daf920be883d4a2
   GoogleSignIn: b232380cf495a429b8095d3178a8d5855b42e842
   GTMAppAuth: 99fb010047ba3973b7026e45393f51f27ab965ae
   GTMSessionFetcher: 41b9ef0b4c08a6db4b7eb51a21ae5183ec99a2c8
diff --git a/frontend/pubspec.lock b/frontend/pubspec.lock
index 8794091..8a7faeb 100644
--- a/frontend/pubspec.lock
+++ b/frontend/pubspec.lock
@@ -1117,7 +1117,7 @@ packages:
     source: hosted
     version: ""1.1.0""
   web:
-    dependency: transitive
+    dependency: ""direct main""
     description:
       name: web
       sha256: ""1d9158c616048c38f712a6646e317a3426da10e884447626167240d45209cbad""
diff --git a/frontend/pubspec.yaml b/frontend/pubspec.yaml
index f98c4fc..457098a 100644
--- a/frontend/pubspec.yaml
+++ b/frontend/pubspec.yaml
@@ -54,6 +54,7 @@ dependencies:
   #sign_in_with_apple: ^5.0.0
 
   dio: any
+  web: ^0.5.0
 dev_dependencies:
   flutter_test:
     sdk: flutter"
    '''
    prompt += "```" + diff + "```"
    #print(prompt)
    #print(summarize_code_change(diff))
    json_code_summarization('git_commits.json', 'git_commits_summarized.json')

if __name__ == "__main__":
    main()
    
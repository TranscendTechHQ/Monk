

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
    prompt = '''
    What does the following code diff inside tripe quotes accomplish? 
    First analyze the diff in each file step by step and create corresponding summaries. 
    Then use the file level summaries to create ONE high-level summary with sufficient detail. 
    Show only the high-level summary to me.\n
    '''
    diff = '''
    
"diff --git a/frontend/lib/repo/search.dart b/frontend/lib/repo/search.dart\nindex 945241a..02441d5 100644\n--- a/frontend/lib/repo/search.dart\n+++ b/frontend/lib/repo/search.dart\n@@ -11,7 +11,7 @@ Future<List<String>> queryMatchingThreads(\n     throw Exception(\"Failed to fetch matching threads\");\n   }\n   final results = response.data!;\n-  print(results);\n+  //print(results);\n \n   return results;\n }\ndiff --git a/frontend/lib/repo/search.g.dart b/frontend/lib/repo/search.g.dart\nindex a68e4cd..a040a26 100644\n--- a/frontend/lib/repo/search.g.dart\n+++ b/frontend/lib/repo/search.g.dart\n@@ -7,7 +7,7 @@ part of 'search.dart';\n // **************************************************************************\n \n String _$queryMatchingThreadsHash() =>\n-    r'010f533458d1b4a1406a1d9a703a253b8881b249';\n+    r'dbb1a0ee4b44ad0894ed99b469ebd7ac5585265d';\n \n /// Copied from Dart SDK\n class _SystemHash {\ndiff --git a/frontend/lib/screens/commandbox.dart b/frontend/lib/screens/commandbox.dart\nindex f57d095..b035839 100644\n--- a/frontend/lib/screens/commandbox.dart\n+++ b/frontend/lib/screens/commandbox.dart\n@@ -1,3 +1,5 @@\n+import 'dart:ffi';\n+\n import 'package:flutter/material.dart';\n import 'package:flutter/services.dart';\n import 'package:flutter_riverpod/flutter_riverpod.dart';\n@@ -28,6 +30,19 @@ class ScreenVisibility extends _$ScreenVisibility {\n   VisibilityEnum get() => state;\n }\n \n+void switchThread(WidgetRef ref, BuildContext context, String newThreadTitle,\n+    String newThreadType) {\n+  final screenVisibility = ref.read(screenVisibilityProvider.notifier);\n+  screenVisibility.setVisibility(VisibilityEnum.thread);\n+\n+  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {\n+    return ThreadScreen(\n+      title: newThreadTitle,\n+      type: newThreadType,\n+    );\n+  }));\n+}\n+\n class CommandTypeAhead extends ConsumerWidget {\n   final TextEditingController _typeAheadController =\n       TextEditingController(text: \"/\");\n@@ -58,24 +73,15 @@ class CommandTypeAhead extends ConsumerWidget {\n                 try {\n                   final newThread = parser.validateCommand(\n                       value, titlesList, commandHintTextNotifier);\n+                  String newThreadType;\n+                  if (threadList.value!.containsKey(newThread[\"title\"])) {\n+                    newThreadType = threadList.value![newThread[\"title\"]]!;\n+                  } else {\n+                    newThreadType = newThread[\"type\"]!;\n+                  }\n+                  switchThread(\n+                      ref, context, newThread[\"title\"]!, newThreadType);\n                   // only if the command was successfully validated\n-                  ref\n-                      .read(screenVisibilityProvider.notifier)\n-                      .setVisibility(VisibilityEnum.thread);\n-\n-                  Navigator.pushReplacement(context,\n-                      MaterialPageRoute(builder: (context) {\n-                    String newTheadType;\n-                    if (threadList.value!.containsKey(newThread[\"title\"])) {\n-                      newTheadType = threadList.value![newThread[\"title\"]]!;\n-                    } else {\n-                      newTheadType = newThread[\"type\"]!;\n-                    }\n-                    return ThreadScreen(\n-                      title: newThread[\"title\"]!,\n-                      type: newTheadType,\n-                    );\n-                  }));\n                 } catch (e) {\n                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(\n                     content: Text(e.toString()),\ndiff --git a/frontend/lib/screens/commandbox.g.dart b/frontend/lib/screens/commandbox.g.dart\nindex f412b3d..2cbe5f8 100644\n--- a/frontend/lib/screens/commandbox.g.dart\n+++ b/frontend/lib/screens/commandbox.g.dart\n@@ -6,7 +6,7 @@ part of 'commandbox.dart';\n // RiverpodGenerator\n // **************************************************************************\n \n-String _$screenVisibilityHash() => r'e895c39f2f75d52169f37c060b3e4a9ca50f1c55';\n+String _$screenVisibilityHash() => r'08fb5340816f0aa36a6c8e4437546d6788ff5a29';\n \n /// See also [ScreenVisibility].\n @ProviderFor(ScreenVisibility)\ndiff --git a/frontend/lib/screens/search.dart b/frontend/lib/screens/search.dart\nindex 47b7192..bfe72ef 100644\n--- a/frontend/lib/screens/search.dart\n+++ b/frontend/lib/screens/search.dart\n@@ -1,6 +1,8 @@\n import 'package:flutter/material.dart';\n import 'package:flutter_riverpod/flutter_riverpod.dart';\n import 'package:frontend/repo/search.dart';\n+import 'package:frontend/repo/thread.dart';\n+import 'package:frontend/screens/commandbox.dart';\n \n class SearchInput extends ConsumerWidget {\n   final FocusNode focusNode;\n@@ -27,16 +29,27 @@ class SearchInput extends ConsumerWidget {\n }\n \n class SearchResults extends ConsumerWidget {\n-  const SearchResults({super.key});\n+  SearchResults({super.key});\n+  int selectedIndex = 0;\n \n   @override\n   Widget build(BuildContext context, WidgetRef ref) {\n     final results = ref.watch(queryResultsProvider);\n+    final threadList = ref.watch(fetchThreadsInfoProvider);\n     return ListView.builder(\n       shrinkWrap: true,\n       itemCount: results.length,\n       itemBuilder: (context, index) {\n         return ListTile(\n+          selectedTileColor: Theme.of(context).colorScheme.shadow,\n+          selected: selectedIndex == index,\n+          onTap: () {\n+            selectedIndex = index;\n+            //print('Selected index: $selectedIndex');\n+            final newThreadTitle = results[index];\n+            final newThreadType = threadList.value![newThreadTitle]!;\n+            switchThread(ref, context, newThreadTitle, newThreadType);\n+          },\n           title: Text(results[index]),\n         );\n       },\n@@ -54,7 +67,7 @@ class SearchModal extends StatelessWidget {\n       mainAxisSize: MainAxisSize.min,\n       children: [\n         SearchInput(focusNode: focusNode),\n-        const SearchResults(),\n+        SearchResults(),\n       ],\n     );\n   }"


    '''
    prompt += "```" + diff + "```"
    #print(prompt)
    print(summarize_code_change(diff))
    #json_code_summarization('git_commits.json', 'git_commits_summarized.json')

if __name__ == "__main__":
    main()
    
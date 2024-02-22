import git
#import csv
## package to read and write json files
import json
#import os
# Path to the git repository
repo_path = '.'

# Open the repository
repo = git.Repo(repo_path)



# Open a CSV file for writing
#csv_file = open('git_commits.csv', 'w', newline='')
#csv_writer = csv.writer(csv_file)


#csv_writer.writerow(['Commit Message', 'Committer Name', 'Commit ID', 'Commit Timestamp', 'Code Diff'])

json_data = []
# Iterate over all commits
for commit in repo.iter_commits():
    commit_message = commit.message
    committer_name = commit.committer.name
    commit_id = commit.hexsha
    commit_timestamp = commit.committed_date
    code_diff = ''
    
    # Get the code diff for the commit
    if commit.parents:
        code_diff = repo.git.diff(commit.parents[0], commit)
        
    json_element = {
        'commit_message': commit_message,
        'committer_name': committer_name,
        'commit_id': commit_id,
        'commit_timestamp': commit_timestamp,
        'code_diff': code_diff
    }
    json_data.append(json_element)
    
    # Write the row to the CSV file
    #csv_writer.writerow([commit_message, committer_name, commit_id, commit_timestamp, code_diff])

# Close the CSV file
#csv_file.close()

# open a json file for writing
json_file = open('git_commits.json', 'w')
json_file.write(json.dumps(json_data, indent=2))
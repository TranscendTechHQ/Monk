# Clustering Project

- The "serverless" folder contains a REST API that exploits serverless GPU computation for topic predictions.
- The "dedicated_server" folder contains a REST API that uses dedicated GPU resources. It is significantly faster than the serverless API.
- The "evaluation" folder contains JSON files with annotated topics and predicted topics. It also contains the eval_jsons.py script that should be run from the terminal and can evaluate the performance of the model.

##### Each folder has more specific and detailed README files inside.
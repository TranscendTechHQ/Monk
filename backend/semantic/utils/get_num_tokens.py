from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.2")

text = """
 Based on the provided context, here's the JSON output for Mariia's classification of topics as relevant or irrelevant:

```json
[
  {
    "Mariia": {
      "relevant": [
        {
          "topic": "396d1eb2-2",
          "reason": "Mariia is a Project Manager and needs regular updates on project status, budget adjustments, and schedule changes. The topic discusses the status of a task and mentions a follow-up, which is relevant to her role."
        },
        {
          "topic": "bd142aab-a",
          "reason": "Mariia needs to stay informed about new tasks assigned to herself or Taras. The topic discusses a meeting for clustering project and mentions several team members, including Mariia."
        },
        {
          "topic": "948edadf-5",
          "reason": "Mariia is interested in project updates and potential issues. The topic discusses REST API issues and improvements, which could impact the project and require her attention."
        }
      ],
      "irrelevant": []
    }
  }
]
```

The topics "Topic 1" and "Topic Clustering: status update" are not provided in the context, so they cannot be classified as relevant or irrelevant for Mariia.
Input size: 2967 tokens

Batch 2 / 3
 Based on the given user information and topics, here is the JSON output:

```json
[
  {
    "Mariia": {
      "relevant": [
        {
          "topic": "3f250d2b-e",
          "reason": "MongoDB integration discussion is relevant as Mariia is a Project Manager and needs to stay informed about project updates, including database integration."
        },
        {
          "topic": "acc7439c-b",
          "reason": "Project Kickoff and Preparation is relevant as Mariia is a Project Manager and needs to be informed about project-related matters."
        }
      ],
      "irrelevant": [
        {
          "topic": "9c81880a-7",
          "reason": "LLM experimentation is irrelevant as Mariia is not interested in delving into technical details."
        },
        {
          "topic": "676d1ce2-1",
          "reason": "RunPod deployment and usage is irrelevant as Mariia is not concerned with technical details or server deployment."
        }
      ]
    }
  }
]
```
Input size: 2839 tokens
"""

print(f"This string is {len(tokenizer.encode(text))} tokens")
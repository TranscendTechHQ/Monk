import json

def extract_topics(broken_json, key):
    try:
        json_data = json.loads(broken_json)
    except json.JSONDecodeError as e:
        pos = e.doc.find("}", e.pos)
        if pos != -1:
            broken_json = broken_json[:pos+1] + "]"
            return extract_topics(broken_json, key)
        else:
            return []
    else:
        return get_topics(json_data, key)

def get_topics(data, key):
    if isinstance(data, dict):
        for k, v in data.items():
            if k == key:
                return [item.get('topic') for item in v if item.get('topic')]
            else:
                return get_topics(v, key)
    elif isinstance(data, list):
        topics = []
        for item in data:
            topics.extend(get_topics(item, key))
        return topics
    else:
        return []

broken_json = """
[
  {
    "Mariia": {
      "relevant": [
        {
          "topic": "1ca8322f-8",
          "reason": "The topic is related to project progress and model deployment, which is relevant to Mariia's role as a project manager."
        }
      ]
    }
  }
]
"Mariia": {
      "irrelevant": [
        {
          "topic": "2za8ab2f-8",
          "reason": "The topic is related to project progress and model deployment, which is relevant to Mariia's role as a project manager."
        }, 
        {"topic": "abcdre-56"}
      ]
    }
  }
"""

relevant_topics = extract_topics(broken_json, 'relevant')
irrelevant_topics = extract_topics(broken_json, 'irrelevant')

print("Relevant topics:", relevant_topics)
print("Irrelevant topics:", irrelevant_topics)
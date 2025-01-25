import re

response = """
    ```
    [
        {
            "Mariia": {
                "relevant": [
                    {
                        "topic": "0257c3",
                        "reason": "Mariia is a Project Manager and scheduling meetings to discuss potential features is relevant to her role."
                    },
                    {
                        "topic": "018658",
                        "reason": "Mariia needs regular updates on project status, including performance evaluations and datasets."
                    },
                    {
                        "topic": "09e0bd",
                        "reason": "Mariia is responsible for staying informed about new tasks assigned by Yogesh or Srikanth, and LLM experimentation might be one of them."
                    }
                ],
                "irrelevant": [
                    {
                        "topic": "07807d",
                        "reason": "Mariia prefers not to delve into technical details, and additional metrics for evaluating similarity of messages is a technical topic."
                    }
                ]
            }
        }
    ]
    ``` 
"""
system_message_for_summary = """
Your task is to summarize the given conversation into laconic summary.
Include only the most important details into your summary.
You will be given topic name and messages belonging to that topic.
The input will be in tripple ticks:
```
Topic "topic name"

- message 1

- message 2

- message 3
```

Give the output in the following format:
In this topic the users are discussing ... They mention ...
"""


user_oneshot_message = """
```
Topic: "Model Training"

- I've gathered the latest dataset for training.
- Do we preprocess data before feeding into the model?
- Yes, normalize features and handle missing values.
- Have we decided on neural network architecture?
- Considering TensorFlow for deep learning.
- Implement cross-validation for model evaluation.
- What about feature engineering techniques?
- Let's explore feature selection and dimensionality reduction.
```
"""


assistant_oneshot_message = """
The chat revolved around model training, covering dataset gathering, 
preprocessing, neural network architecture considerations (like TensorFlow), c
ross-validation implementation, and feature engineering exploration.
"""
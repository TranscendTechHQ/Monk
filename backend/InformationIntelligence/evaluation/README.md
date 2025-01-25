# Evaluation on annotated data

Example of using eval_jsons.py from the terminal:

eval_jsons.py expects two arguments:
- A JSON file with a 'label' key.
- A JSON file with a 'predicted topic' key.

-You can use the output of the REST API endpoint as the second argument as long as it has a JSON file with corresponding annotated labels.

```
input:
python eval_jsons.py --labels=scikit-learn_labels.json --preds=scikit-learn_preds.json

output:
348 Golden links
355 Auto links
Model predicted 214 Golden links: 60.28%
```

Accuracy on annotated data:

- data-8.json
```
486 Golden links
499 Auto links
Model predicted 330 Golden links: 66.13%
```

- h20ai.json (400 rows)
```
331 Golden links
351 Auto links
Model predicted 193 Golden links: 54.99%
```

- scikit-learn (400 rows)
```
348 Golden links
355 Auto links
Model predicted 214 Golden links: 60.28%
```
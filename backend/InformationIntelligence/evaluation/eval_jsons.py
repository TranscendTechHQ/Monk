import argparse
import json
import pandas as pd


def find_links(df, column):
    total_links = []
    label_groups = df.groupby(column).groups

    for _, indices in label_groups.items():
        if len(indices) > 1:
            for i in range(len(indices)):
                for j in range(i + 1, len(indices)):
                    total_links.append((indices[i], indices[j]))
                    break

    return total_links


def main(args):
    with open(args.labels, "r") as json_file:
        data_labels = json.load(json_file)

    with open(args.preds, "r") as json_file:
        data_preds = json.load(json_file)

    label_list = [data_labels["label"][key] for key in data_labels["label"]]
    prediction_list = [data_preds["predicted topic"][key] for key in data_preds["predicted topic"]]

    df_eval = pd.DataFrame({"label": label_list, "prediction": prediction_list})

    golden_links = find_links(df_eval, "label")
    auto_links = find_links(df_eval, "prediction")

    num_of_matches = 0
    number_of_total = 0
    for link in auto_links:
        if link in golden_links:
            num_of_matches += 1
        number_of_total += 1

    print(f"""
    {len(golden_links)} Golden links
    {len(auto_links)} Auto links
    Model predicted {num_of_matches} Golden links: {round(num_of_matches/number_of_total*100, 2)}%
    """)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process evaluation data and calculate predictions.')
    parser.add_argument('--labels', type=str, help='Path to the JSON labels file.', required=True)
    parser.add_argument('--preds', type=str, help='Path to the JSON predictions file.', required=True)
    args = parser.parse_args()
    main(args)

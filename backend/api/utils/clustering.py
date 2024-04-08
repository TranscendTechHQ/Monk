# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import numpy as np
from sklearn.cluster import KMeans
import vertexai

PROJECT_ID = "monk-386620"
REGION = "us-central1"
vertexai.init(project=PROJECT_ID, location=REGION)


from vertexai.language_models import TextEmbeddingInput, TextEmbeddingModel


def embed_text(
    model_name: str,
    task_type: str,
    text: str,
    title: str = "",
    output_dimensionality=None,
) -> list:
    """Generates a text embedding with a Large Language Model."""
    model = TextEmbeddingModel.from_pretrained(model_name)
    text_embedding_input = TextEmbeddingInput(
        task_type=task_type, title=title, text=text
    )
    kwargs = (
        dict(output_dimensionality=output_dimensionality)
        if output_dimensionality
        else {}
    )
    embeddings = model.get_embeddings([text_embedding_input], **kwargs)
    return embeddings[0].values


def unsupervised_cluster(embeddings, n_clusters):
  """
  Performs unsupervised clustering on text vector embeddings using K-Means.

  Args:
      embeddings: A numpy array of shape (n_samples, embedding_dim) containing the text vector embeddings.
      n_clusters: The desired number of clusters.

  Returns:
      A list of cluster labels for each data point.
  """
  # KMeans clustering
  kmeans = KMeans(n_clusters=n_clusters, random_state=1, 
                  #algorithm='elkan'
                  )
  kmeans.fit(embeddings)

  # Get cluster labels
  cluster_labels = kmeans.labels_

  return cluster_labels

def single_text_embedding(text:str):
    
    # @title { run: "auto" }
    MODEL = "text-embedding-preview-0409"  # @param ["text-embedding-preview-0409", "text-multilingual-embedding-preview-0409", "textembedding-gecko@003", "textembedding-gecko-multilingual@001"]
    TASK = "CLUSTERING"  # @param ["RETRIEVAL_QUERY", "RETRIEVAL_DOCUMENT", "SEMANTIC_SIMILARITY", "CLASSIFICATION", "CLUSTERING", "QUESTION_ANSWERING", "FACT_VERIFICATION"]
    TEXT = text
    TITLE = ""  # @param {type:"string"}
    OUTPUT_DIMENSIONALITY = 256  # @param [1, 768, "None"] {type:"raw", allow-input:true}

    if not MODEL:
        raise ValueError("MODEL must be specified.")
    if not TEXT:
        raise ValueError("TEXT must be specified.")
    if TITLE and TASK != "RETRIEVAL_DOCUMENT":
        raise ValueError("TITLE can only be specified for TASK 'RETRIEVAL_DOCUMENT'")
    if OUTPUT_DIMENSIONALITY is not None and MODEL not in [
        "text-embedding-preview-0409",
        "text-multilingual-embedding-preview-0409",
    ]:
        raise ValueError(f"OUTPUT_DIMENTIONALITY cannot be specified for model '{MODEL}'.")
    if TASK in ["QUESTION_ANSWERING", "FACT_VERIFICATION"] and MODEL not in [
        "text-embedding-preview-0409",
        "text-multilingual-embedding-preview-0409",
    ]:
        raise ValueError(f"TASK '{TASK}' is not valid for model '{MODEL}'.")
    # Get a text embedding for a downstream task.
    embedding = embed_text(
        model_name=MODEL,
        task_type=TASK,
        text=TEXT,
        title=TITLE,
        output_dimensionality=OUTPUT_DIMENSIONALITY,
    )
    #print(embedding)  # Expected value: {OUTPUT_DIMENSIONALITY}. 
    return embedding

def embedding_array(text_array_input):
    
    embedding_array = []
    for text in text_array_input:
        embedding = single_text_embedding(text)
        embedding_array.append(embedding)
    numpy_array = np.array(embedding_array)
    return numpy_array
    

def main():
    input_array = ["Hey how are you?",
         "How is the weather today?", 
         "I am fine",
         "It is sunny today.", 
         "good.", 
         "How about you?", 
         "what is your name?", 
         "My name is Monk."
         ]
    # Example usage
    # Assuming you have your text vector embeddings in a numpy array named 'embeddings'
    embeddings = embedding_array(
        input_array
        )  # Your embedding data

    # Set the desired number of clusters
    n_clusters = 2

    # Get cluster labels for each text embedding
    cluster_labels = unsupervised_cluster(embeddings, n_clusters)

    for i in range (0, n_clusters):
        print(f"Cluster {i}:")
        for j in range (0, len(input_array)):
            if cluster_labels[j] == i:
                print(input_array[j])
        print("\n\n")
    # Print the cluster labels
    #print(cluster_labels)



if __name__ == "__main__":  
    main()
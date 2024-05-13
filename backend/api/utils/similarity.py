import os

import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

from embedding import generate_embedding


# Define the topics
topics = [
    """
    Topic 1
    - real-time os version released.
    - with this we can write deterministic embedded software
    - good news! is there any market demand for this?
    - we will see. Build it and they will come!
    - ha ha. aren't we too optimistic?
    - I am gonna present it in our customer appreciation conference next month in Canberra
    """,
    """
    Topic 2
    - kubernetes allows to run containers at scale
    - customers who have applications with millions of users need their applications to scale horizontally.
    - yeah, but our customers are SMB. They don't need scale.
    """,
    """
    Topic 3
    - chatgpt will challenge the SEO landscape
    - Now search is no longer going to provide a list of links
    - moreover, websites cannot just contain keywords that are picked up by the search engine
    - AI assistants directly provide answers, often constructed from multiple sources.
    - Really? Do they provide back references to the sources?
    - Some of them do, yeah.
    - Then there is still scope for useful content driving users back to our website!
    - True. May be we can use LLM to write content?
    - I said useful content :)
    - lol
    """,
    """
    Topic 4
    - we need to hire more people from the minority community
    - Why?
    - because we want to create more diversity in our workforce
    - What is diversity based on?
    - socio economic conditions, ethnicity, race, religion, language, gender etc.
    - hmmm, as long as we don't compromise our standards of merit and skillset, I am all for it. Remember, we have a business to run.
    - Noted.
    """,
    """
    Topic 5
    - new method to create awareness for our products
    - we will sell NFTs of animated version of our products!
    - how many people buy NFTs?
    - a lot, it's all the craze right now.
    - are the people buying NFTs in our target customer segment?
    - does it matter?
    - YES !!!!
    """,
    """
    New Topic
    - how should we integrate generative AI in our product roadmap?
    - I say we should implement a chatbot and integrate in all our products.
    - Then we can say in our investor call that 95% of our revenues are coming from AI and our stock price will double
    - That is the stupidest idea ever. Our products are mostly hardware with very little memory, and CPU. We don't even have a GPU. Where will the models run?
    - isn't this your job as an engineer to figure it out?
    - can't you do your job and sell products without using 'generative AI' in every second sentence?
    - calm down guys. Skynet is listening!
    """
]

# Get embeddings for each topic using text-embedding-3-small
embeddings = [
    generate_embedding(topic)
    for topic in topics
]

# Compute pairwise cosine similarity matrix
similarity_matrix = 1 - cosine_similarity(embeddings)

# Find the most similar topic to the "New Topic"
new_topic_idx = -1
most_similar_idx = np.argsort(similarity_matrix[-1])[1]  # Skip the first result (itself)
print(f"New Topic is most similar to Topic {most_similar_idx}")
print(f"Similarity score: {similarity_matrix[-1][most_similar_idx]:.4f}")
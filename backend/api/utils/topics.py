

from bertopic import BERTopic
from sklearn.datasets import fetch_20newsgroups

#docs = fetch_20newsgroups(subset='all',  remove=('headers', 'footers', 'quotes'))['data']
docs = ["Hey how are you?",
         "How is the weather today?", 
         "I am fine",
         "It is sunny today.", 
         "good.", 
         "How about you?", 
         "what is your name?", 
         "My name is Monk.",
         "which algo should we use?",
         "how about bertopic?",
         "yeah, I am fine as long as it works",
         "who makes the best thaali in town?",
         "tirupati bhavan",
         "you mean tirupati bhimas?",
         "yeah, that's the one",
         "I am hungry",
         "you are always hungry",
         "which is the best marvel movie?",
         "infinity war",
         "I think it is Dr. Strange",
         "yeah that was good too",
         "I am bored",
         "you wanna watch a movie?",
            "sure, which one?",
            "how about inception?",
            "I have seen it already",
            "what about interstellar?",
            "I have seen that too",
            "what about the dark knight?",
            "can we not watch christopher nolan movies?",
            "okay, how about the matrix?",
            "fine."
            
         ]
#print(docs[0])
topic_model = BERTopic()
topics, probs = topic_model.fit_transform(docs)

info = topic_model.get_document_info(docs)
print(info)


#print(topics)

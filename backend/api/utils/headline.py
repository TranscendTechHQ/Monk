import os

from langchain.chains.llm import LLMChain
from langchain.prompts import PromptTemplate
# Define prompt
from langchain_openai import ChatOpenAI

from config import settings

os.environ["OPENAI_API_KEY"] = settings.OPENAI_API_KEY
os.environ["OPENAI_API_ENDPOINT"] = "https://api.openai.com"
os.environ["OPENAI_API_VERSION"] = "2023-05-15"


def generate_headline(text: str) -> str:
    # Define prompt

    prompt_template = """Imagine the following text in
    triple quotes is from a concatenated tweetstorm. 
    Generate a concise headline, maximum 1-2 sentences long, 
    such the reader gets the gist just by reading the headline. 
    If the text is empty, just generate an empty text as headline. 
    Also, directly print the headline without any filler text like 'the headline is':
    "{text}"
    headline:"""
    prompt = PromptTemplate.from_template(prompt_template)

    # Define LLM chain
    llm = ChatOpenAI(temperature=0, model_name="gpt-3.5-turbo-16k")
    llm_chain = LLMChain(llm=llm, prompt=prompt)

    # Define StuffDocumentsChain
    ##stuff_chain = StuffDocumentsChain(llm_chain=llm_chain, document_variable_name="text")

    # docs = loader.load()

    headline = llm_chain.invoke(text)
    # print(summary)
    return headline


<<<<<<< Updated upstream
def generate_single_thread_headline(thread_doc, headline_collection,
                                    useAI=False):
=======
def generate_single_thread_headline(thread_doc, threads_collection, useAI=False):
>>>>>>> Stashed changes
    blocks = thread_doc['content']
    headline = {}
    if useAI:
        text = ""
        for block in blocks:
            # print(block['content'])
            text += block['content'] + " "
        headline = generate_headline(text)

    else:
        # print(thread_doc['title'])

        if len(blocks) > 0:
            headline['text'] = blocks[0]['content']
            headline['last_modified'] = str(blocks[-1]['created_at'])
        else:
            headline['text'] = "blank thread"
<<<<<<< Updated upstream
            headline['last_modified'] = str(thread_doc['created_date'])
=======
            headline['last_modified']= str(thread_doc['created_date'])

        threads_collection.update_one({'_id': thread_doc['_id']},
                                      {'$set': {'headline': headline['text'],
                                                'last_modified': headline['last_modified']}}, upsert=True)
        
>>>>>>> Stashed changes

        title = thread_doc['title']
        headline_collection.update_one({'_id': thread_doc['_id']},
                                       {'$set': {'headline': headline['text'],
                                                 'title': title,
                                                 'last_modified': headline['last_modified']}}, upsert=True)

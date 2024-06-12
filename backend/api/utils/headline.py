import asyncio
import os

from langchain.chains.llm import LLMChain
from langchain.prompts import PromptTemplate
# Define prompt
from langchain_openai import ChatOpenAI
from utils.db import  shutdown_sync_db_client, startup_sync_db_client, syncdb


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
    # stuff_chain = StuffDocumentsChain(llm_chain=llm_chain, document_variable_name="text")

    # docs = loader.load()

    headline_with_quotes = llm_chain.invoke(text)['text']
    headline = headline_with_quotes.replace('"', '')
    # print(summary)
    return headline

def update_single_headline_in_db(thread_doc, headline):
    #print(f"Updating headline for thread {thread_doc['_id']} to {headline}")
    
    threads_collection = syncdb.threads_collection
    result = threads_collection.update_one({'_id': thread_doc['_id']},
                                      {'$set': {'headline': headline}}, upsert=True)
    #print(result.raw_result)

def set_first_block_as_headline(thread_id, num_blocks, block_content):
    if num_blocks == 1:
        headline = block_content
        threads_collection = syncdb.threads_collection
        threads_collection.update_one({'_id': thread_id},
                                      {'$set': {'headline': headline}}, upsert=True)
       
    
def generate_single_thread_headline(thread_id, use_ai=False):
    #blocks = thread_doc['content']
    threads_collection = syncdb.threads_collection
    thread_doc =  threads_collection.find_one({'_id': thread_id})
    if not thread_doc:
        raise ValueError("Thread with id {thread_id} not found")
    
    num_blocks = thread_doc['num_blocks']
    
    headline = "blank thread"
    if num_blocks == 0:
        update_single_headline_in_db(thread_doc, headline)
        return
    
    blocks_collection = syncdb.blocks_collection
    default_block = blocks_collection.find_one({'child_thread_id': thread_id})
    
    blocks = []
    
    if default_block:
        if not use_ai:
            
            headline = default_block['content']
            
            update_single_headline_in_db(thread_doc, headline)
            return
        else:
            blocks.append(default_block)
        
    more_blocks =  list(blocks_collection.find(
        {'main_thread_id': thread_id}).sort('position', 1))
    blocks.extend(more_blocks)
        
    if use_ai:
        
        text = ""
        for block in blocks:
            # print(block['content'])
            text += block['content'] + " "
        headline = generate_headline(text)

    else:
        # print(thread_doc['topic'])
        first_block = blocks[0]
        
        headline = first_block['content']
        
    #print(f"Updating headline for thread {thread_id} to {headline}")
    update_single_headline_in_db(thread_doc, headline)
    
    
def generate_all_thread_headlines(use_ai=False):
    thread_collection = syncdb.threads_collection
    threads = list(thread_collection.find({}))
    # headline_collection = app.mongodb["thread_headlines"]
    for doc in threads:
        print(f"Generating headline for thread {doc['_id']}")
        generate_single_thread_headline(thread_id=doc["_id"], use_ai=use_ai)

        # pprint.pprint(headline['text'])
        
    
async def main():
    startup_sync_db_client()
    generate_all_thread_headlines(use_ai=True)
    #await generate_single_thread_headline("af6f0744-0679-47d4-8838-db02312cc61e", use_ai=True)
    shutdown_sync_db_client()


if __name__ == "__main__":
    asyncio.run(main())
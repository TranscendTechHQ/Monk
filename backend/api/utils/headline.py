import asyncio
import os

from langchain.chains.llm import LLMChain
from langchain.prompts import PromptTemplate
# Define prompt
from langchain_openai import ChatOpenAI
from utils.db import asyncdb
from utils.db import shutdown_async_db_client, startup_async_db_client

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

    headline = llm_chain.invoke(text)
    # print(summary)
    return headline

def update_single_headline_in_db(thread_doc, headline):
    #print(f"Updating headline for thread {thread_doc['_id']} to {headline}")
    
    threads_collection = asyncdb.threads_collection
    threads_collection.update_one({'_id': thread_doc['_id']},
                                      {'$set': {'headline': headline}}, upsert=True)

async def generate_single_thread_headline(thread_id, use_ai=False):
    #blocks = thread_doc['content']
    threads_collection = asyncdb.threads_collection
    thread_doc = await threads_collection.find_one({'_id': thread_id})
    if not thread_doc:
        raise ValueError("Thread with id {thread_id} not found")
    
    num_blocks = thread_doc['num_blocks']
    
    headline = "blank thread"
    if num_blocks == 0:
        update_single_headline_in_db(thread_doc, headline)
        return
    
    blocks_collection = asyncdb.blocks_collection
    default_block = await blocks_collection.find_one({'child_thread_id': thread_id})
    
    blocks = []
    
    if default_block:
        if not use_ai:
            
            headline = default_block['content']
            
            update_single_headline_in_db(thread_doc, headline)
            return
        else:
            blocks.append(default_block)
        
    more_blocks = await blocks_collection.find(
        {'main_thread_id': thread_id}).sort('position', 1).to_list(length=None)
    blocks.extend(more_blocks)
        
    if use_ai:
        
        text = ""
        for block in blocks:
            # print(block['content'])
            text += block['content'] + " "
        headline = generate_headline(text)

    else:
        # print(thread_doc['title'])
        first_block = blocks[0]
        
        headline = first_block['content']
        

    update_single_headline_in_db(thread_doc, headline)
    
    
async def generate_all_thread_headlines(use_ai=False):
    thread_collection = asyncdb.threads_collection
    threads = await thread_collection.find({}).to_list(length=None)
    # headline_collection = app.mongodb["thread_headlines"]
    for doc in threads:
        print(f"Generating headline for thread {doc['_id']}")
        await generate_single_thread_headline(thread_id=doc["_id"], use_ai=use_ai)

        # pprint.pprint(headline['text'])
        
    
async def main():
    await startup_async_db_client()
    await generate_all_thread_headlines(use_ai=False)
    #await generate_single_thread_headline("af6f0744-0679-47d4-8838-db02312cc61e", use_ai=False)
    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
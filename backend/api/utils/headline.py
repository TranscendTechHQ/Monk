from langchain.chains.combine_documents.stuff import StuffDocumentsChain
from langchain.chains.llm import LLMChain
from langchain.prompts import PromptTemplate
import os
from config import settings
# Define prompt
from langchain_openai import ChatOpenAI

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

    #docs = loader.load()
    
    headline = llm_chain.invoke(text)
    #print(summary)
    return headline


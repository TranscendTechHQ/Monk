system_message = """
You will be given a list of facts about people and their preferences in the following format shown in triple quotes
```
Robert 
- is a marketing person
- oversees all marketing operations for software products
- does not like hardware product discussions
```

Then user will provide you a list of topics and corresponding conversation messages in the following format in triple quotes.
```
Topic 1
- message 1
- message 2
- message 3

Topic 2
- message 1
- message 2
- message 3
```

You need to classify each topics as either relevant or irrelevant for each person. Show the output in the following JSON format.
```
[
{ "person 1":
"relevant": {
[
{"topic": "topic1"
"reason": "because person 1 likes xyz and this topic mentions something related"}
]

"irrelevant": {
[
{"topic": "topic1"
"reason": "because person 1 hates anything related to abc "}
]
]
```
"""

user_onseshot_message = """
User:
Kiran
- software guy
- writes embedded software 
- hates meetings

Topics:
Topic: 1
- real-time os version released.
- with this we can write deterministic embedded software
- good news! is there any market demand for this?
- we will see. Build it and they will come!
- ha ha. aren't we too optimistic?
- I am gonna present it in our customer appreciation conference next month in Canberra


Topic: 2
- kubernetes allows to run containers at scale
- customers who have applications with millions of users need their applications to scale horizontally.
- yeah, but our customers are SMB. They don't need scale.


Topic: 3
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


Topic: 4
- we need to hire more people from the minority community
- Why?
- because we want to create more diversity in our workforce
- What is diversity based on?
- socio economic conditions, ethnicity, race, religion, language, gender etc.
- hmmm, as long as we don't compromise our standards of merit and skillset, I am all for it. Remember, we have a business to run. 
- Noted.


Topic: 5
- new method to create awareness for our products
- we will sell NFTs of animated version of our products!
- how many people buy NFTs?
- a lot, it's all the craze right now.
- are the people buying NFTs in our target customer segment?
- does it matter?
- YES !!!!
"""


assistant_oneshot_message = """
[{
    "Kiran": {
        "relevant": [
            {
                "topic": "Topic 1",
                "reason": "Kiran writes embedded software, so the discussion about real-time OS and deterministic software is relevant to him"
            }
        ],
        "irrelevant": [
            {
                "topic": "Topic 2",
                "reason": "Kiran works with embedded software and has no interest in container scaling"
            },
            {
                "topic": "Topic 3",
                "reason": "Kiran does not like meetings and this topic seems unrelated to his preferences"
            },
            {
                "topic": "Topic 4",
                "reason": "Kiran is focused on software development and not interested in DEI discussions"
            },
            {
                "topic": "Topic 5",
                "reason": "Kiran is in software and not likely to be interested in NFTs and product awareness methods"
            }
        ]
    }
}]
"""

# formatted input from user
user_message = input(...) 

chat = [
    {"role": "system", "content": system_message},
    {"role": "user", "content": user_onseshot_message},
    {"role": "assistant", "content": assistant_oneshot_message},
    {"role": "user", "content": user_message}
]

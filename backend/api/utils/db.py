import datetime as dt

## first argument should be a dictionary to query the db
async def get_mongo_document(query: dict, collection):
    if (doc := await collection.find_one(query)) is not None:
        return doc
    return None

async def get_mongo_documents(collection):
    docs = []
    async for doc in collection.find():
        docs.append(doc)
    return docs

async def get_mongo_documents_by_date(date: dt.datetime, collection):

   # async for doc in collection.find({"metadata.createdAt": date}):
    #    docs.append(doc)
    d = date.date()
    from_date = dt.datetime.combine(d, dt.datetime.min.time())
    
    
    to_date = dt.datetime.combine(d, dt.datetime.max.time())
    
    query = {"created_at": {"$gte": from_date.isoformat(), "$lt": to_date.isoformat()}}
    
    cursor =  collection.find(query)
    batch_size = 100
    # Convert cursor to list of dictionaries
    documents = await cursor.to_list(length=batch_size)
    
    return documents

async def delete_mongo_document(query:dict, collection):
    if (doc := await collection.find_one(query)) is not None:
        await collection.delete_one(query)
        return doc

async def create_mongo_document(document: dict, collection):

    new_document = await collection.insert_one(document)
    
    created_document = await collection.find_one(
        {"_id": new_document.inserted_id})
    
    return created_document

async def update_mongo_document_fields(query:dict, fields: dict, collection):
    fields_dict = {k: v for k, v in fields.dict().items() if v is not None}

    if len(fields_dict) >= 1:
        update_result = await collection.update_one(
            query, {"$set": fields_dict}
        )

        if update_result.modified_count == 1:
            if (
                updated_doc := await collection.find_one(query)
            ) is not None:
                return updated_doc

    if (
        existing_doc := await collection.find_one(query)
    ) is not None:
        return existing_doc

    return None
from fastapi import FastAPI, File, Form, UploadFile
from fastapi import FastAPI, HTTPException, Security, status
from fastapi.security import APIKeyHeader
import pathlib
import asyncio
import io
import pandas as pd
from fastapi.responses import StreamingResponse
from preprocessing import get_batches, get_last_batches, generate_json_list
from openai import AsyncOpenAI


model_name='mistralai/Mistral-7B-Instruct-v0.2'
api_keys = [
    "my_api_key"
]
dir_names = {
    "my_api_key":"yogesh"
}

client = AsyncOpenAI(
    api_key="DLVUJWLDM1FRZVAQB3N8QRG56NQBACQZT2M0QNLD",
    base_url="https://api.runpod.ai/v2/vllm-a1iwyc8euiv13t/openai/v1",
    timeout=999999999
)

app = FastAPI()
api_key_header = APIKeyHeader(name="X-API-Key")


def get_api_key(api_key_header: str = Security(api_key_header)) -> str:
    if api_key_header in api_keys:
        return api_key_header
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or missing API Key",
    )


@app.post("/process_csv/")
async def process_csv(file: UploadFile = File(...), chat_name: str = Form(...), api_key: str = Security(get_api_key)):

    dir_name = dir_names[api_key]
    dir_path = pathlib.Path(dir_name)
    dir_path.mkdir(parents=True, exist_ok=True)
    file_name = f"{chat_name}.csv"
    file_path = dir_path / file_name
    temp_file_name = f"temp_{chat_name}.csv"
    temp_file_path = dir_path / temp_file_name

    while temp_file_path.exists():
        await asyncio.sleep(10)

    if not file_path.exists():
        try:
            file_contents = await file.read()
            stream_file_contents = io.BytesIO(file_contents)
            current_df = pd.read_json(stream_file_contents)
            batches, current_df = get_batches(current_df)

            all_id_topic_pairs = {}
            for idx, subbatch in enumerate(batches):
                print(f"Batch: {idx+1}")
                success = False

                while not success:
                    outputs = await client.chat.completions.create(
                        model=model_name,
                        messages=subbatch,
                        temperature=0.3,
                        max_tokens=4096
                    )
                    
                    outputs = outputs.choices[0].message.content
                    try:
                        id_topic_pairs = generate_json_list(outputs)
                        all_id_topic_pairs.update(id_topic_pairs)
                        success = True
                        print("done")
                    except Exception as e:
                        print(str(e))


            current_df["predicted topic"] = current_df["id"].apply(lambda id: all_id_topic_pairs[id] if str(id) in all_id_topic_pairs else None)
            current_df = current_df[["message", "time", "user", "message.1", "predicted topic"]]
            towrite = io.BytesIO()
            current_df.to_json(towrite)
            towrite.seek(0)
            current_df.to_csv(file_path, index=False)

            return StreamingResponse(
                    towrite,
                    media_type="text/json",
                    headers={"Content-Disposition": f"attachment; filename=data.json"}
            )
        
        except Exception as e:
            return {"success": False, "error": str(e)}

    else:
        print("second method")
        file_path.rename(temp_file_path)
        try:
            file_contents = await file.read()
            stream_file_contents = io.BytesIO(file_contents)
            df_new = pd.read_csv(stream_file_contents)
            df_old = pd.read_csv(temp_file_path)
            current_df, messages_for_consideration = get_last_batches(df_old, df_new, batch_size=40)
            batches, current_df = get_batches(current_df)

            all_id_topic_pairs = {}

            for idx, subbatch in enumerate(batches):
                print(f"Batch: {idx+1}")
                success = False

                while not success:
                    outputs = await client.chat.completions.create(
                        model=model_name,
                        messages=subbatch,
                        temperature=0.3,
                        max_tokens=4096,
                    )
                    outputs = outputs.choices[0].message.content
                    try:
                        id_topic_pairs = generate_json_list(outputs)
                        all_id_topic_pairs.update(id_topic_pairs)
                        success = True
                        print("done")
                    except Exception as e:
                        print(str(e))


            current_df["predicted topic"] = current_df["id"].apply(lambda id: all_id_topic_pairs[id] if str(id) in all_id_topic_pairs else None)
            current_df = current_df[["message", "time", "user", "message.1", "predicted topic"]]
            df_cat = pd.concat([df_old.iloc[:-messages_for_consideration], current_df], axis=0)

            towrite = io.BytesIO()
            df_cat.to_json(towrite)
            towrite.seek(0)
            temp_file_path.unlink()
            df_cat.to_csv(file_path, index=False)

            return StreamingResponse(
                    towrite,
                    media_type="text/json",
                    headers={"Content-Disposition": f"attachment; filename=data.json"}
            )

        except Exception as e:
            return {"success": False, "error": str(e)}

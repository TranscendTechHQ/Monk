# Serverless

### Configuration of serverles API.

#### Part 1
1. Navigate to: https://www.runpod.io/console/serverless
2. Press the "Start" button for vLLM in the Quick Deploy section.
3. Enter Hogging Face Repo: mistralai/Mistral-7B-Instruct-v0.2 and Hugging Face Token: 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 or your personal token.
4. Click "Next". Then click "Next" in tab 2.
5. In tab 3, choose a 24 GB GPU, set Active Workers=0, Max Workers=1, GPUs/Worker=1, Idle Timeout=120s, and FlashBoot=True.
6. Deploy the serverless endpoint.

#### Part 2
7. Navigate to: https://www.runpod.io/console/pods
8. Click the "Deploy" button and select a CPU with 8 GB of RAM.
9. In the "Configure Deployment" window, use the "On-Demand" instance pricing. It's more expensive, but it will ensure that the pod can't be interrupted.
10. In the "Configure Deployment" window, click the "Edit Template" button and set 20 GB for the container disk. Also, expose some HTTP ports for communication with this server, for example, three different ports in the 8XXX range.
11. In the "Configure Deployment" window, select the "SSH Terminal Access" and "Start Jupyter Notebook" checkboxes. (Note: You should add your public SSH key in RunPod settings for terminal access.)
12. Deploy the pod On-Demand.
13. Navigate to Pods and click the "Connect" button. (This connection requires VS Code. [Link to YouTube video instruction (Starts from 3 minutes)](https://www.youtube.com/watch?v=vEVDoW-uMHI))
14. Create a new virtual environment, load code, and install dependencies from requirements.txt in the workspace directory.
15. Change the RunPod API key and enter the valid serverless endpoint link in lines 21-25 of your code.
```python 
client = AsyncOpenAI(
    api_key="1VXVAEDTBTHFJ1OUPVC3RVFNFU2E2BEROHXB0FYU",
    base_url="https://api.runpod.ai/v2/vllm-mgqnwa6pnoh61r/openai/v1",
    timeout=999999999
)
```
16. You can find the valid link in the created serverless endpoint at https://www.runpod.io/console/serverless. The API key should be created in RunPod settings at https://www.runpod.io/console/user/settings.
17. Navigate to the workspace directory and start the API with the command uvicorn main:app --reload --host=0.0.0.0 --port=[Your exposed port].
18. Now you can access the API at http://0.0.0.0:[Your exposed port]/docs.
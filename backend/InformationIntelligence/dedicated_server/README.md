# Dedicated Server

### Configuration of dedicated server on RunPod.


1. Navigate to: https://www.runpod.io/console/pods
2. Click the "Deploy" button and select any GPU with 48 GB of VRAM. (You can use both "Secure Cloud" and "Community Cloud".)
3. In the "Configure Deployment" window, use the "On-Demand" instance pricing. It's more expensive, but it will ensure that the pod can't be interrupted.
4. In the "Configure Deployment" window, click the "Edit Template" button and set 80 GB for both the container disk and volume disk. Also, expose some HTTP ports for communication with this server, for example, three different ports in the 8XXX range.
5. In the "Configure Deployment" window, select the "SSH Terminal Access" and "Start Jupyter Notebook" checkboxes. (Note: You should add your public SSH key in RunPod settings for terminal access.)
6. Deploy the pod On-Demand.
7. Navigate to Pods and click the "Connect" button. (This connection requires VS Code. [Link to YouTube video instruction (Starts from 3 minutes)](https://www.youtube.com/watch?v=vEVDoW-uMHI))
8. Create a new virtual environment, load code, and install dependencies from requirements.txt in the workspace directory.
9. Navigate to the workspace directory and start the API with the command `uvicorn main:app --reload --host=0.0.0.0 --port=[Your exposed port]`.
10. Now you can access the API at http://0.0.0.0:[Your exposed port]/docs.
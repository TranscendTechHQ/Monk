import pytest
from playwright.async_api import async_playwright
import dotenv
import os
dotenv.load_dotenv()

ENDPOINTS = [
    ("GET", "/upload-url?filename=test.txt"),
    ("GET", "/download-url?filename=test.txt"),
    ("POST", "/message?thread_id=test_thread&text=Hello"),
    ("GET", "/threads"),
    ("GET", "/users"),
    ("GET", "/searchThreads?query=testing")
]

@pytest.mark.asyncio
async def test_unauthorized_access():
    async with async_playwright() as p:
        request = await p.request.new_context()
        base_url = os.getenv("API_DOMAIN")
        
        for method, path in ENDPOINTS:
            url = f"{base_url}{path}"
            
            if method == "GET":
                response = await request.get(url)
            elif method == "POST":
                response = await request.post(url)
            
            assert response.status == 401, \
                f"Expected 401 for {method} {url}, got {response.status}"
        
        await request.dispose() 
import requests
import os


def get_access_token():
    HCP_CLIENT_ID = os.getenv('HCP_CLIENT_ID')
    HCP_CLIENT_SECRET = os.getenv('HCP_CLIENT_SECRET')

    url = "https://auth.idp.hashicorp.com/oauth2/token"

    payload = f'client_id={HCP_CLIENT_ID}&client_secret={HCP_CLIENT_SECRET}&grant_type=client_credentials&audience=https%3A%2F%2Fapi.hashicorp.cloud'
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'did=s%3Av0%3A5c2652b0-f28d-11ee-a514-21f974460605.5NTWtjhx0140nTHe1NaFIh0%2FV3CL9Ba7GXOWUOt5F%2BQ; did_compat=s%3Av0%3A5c2652b0-f28d-11ee-a514-21f974460605.5NTWtjhx0140nTHe1NaFIh0%2FV3CL9Ba7GXOWUOt5F%2BQ'
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    return response.json()['access_token']


def get_secret(secret, token):
    HCP_ORG_ID = os.getenv('HCP_ORG_ID')
    HCP_PROJECT_ID = os.getenv('HCP_PROJECT_ID')
    url = f"https://api.cloud.hashicorp.com/secrets/2023-06-13/organizations/{HCP_ORG_ID}/projects/{HCP_PROJECT_ID}/apps/monk-secrets/open/{secret}"

    payload = {}
    headers = {
        'Authorization': f'Bearer {token}'
    }

    response = requests.request("GET", url, headers=headers, data=payload)

    return response.json()['secret']['version']['value']


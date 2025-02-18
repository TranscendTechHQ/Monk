from config import settings
if __name__ == '__main__':
    import uvicorn
    from argparse import ArgumentParser

    parser = ArgumentParser(description='Input read and write info')
    parser.add_argument('-p', '--port', default=settings.PORT, type=int)
    parser.add_argument('-m', '--model_type', choices=['runpod', 'cloudflare_endpoint'])
    parser.add_argument('-r', '--read_from', choices=['json', 'mongo'])

    args = parser.parse_args()
    port = args.port
    model_type = args.model_type
    read_from = args.read_from

    uvicorn.run('main:app', host='0.0.0.0', port=port, reload=True)
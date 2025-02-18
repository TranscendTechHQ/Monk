from bs4 import BeautifulSoup
import requests


def getLinkMeta(url: str):
    print('\nURL :', url)
    url = formatUrl(url)
    r = requests.get(url, verify=False)
    soup = BeautifulSoup(r.content, "html.parser",
                         from_encoding="utf-8", )

    # Get topic string from soup if is is not None
    topic = soup.topic.string if soup.topic is not None else ''
    print('TITLE IS :', topic)

    meta = soup.find_all('meta')
    print('TOTAL META TAGS :', len(meta))
    results = {
        'url': url,
        'topic': topic,
    }
    tags = tagList()
    for tag in meta:
        try:
            if 'name' in tag.attrs.keys() and tag.attrs['name'].strip().lower() in tags:
                # print(tag.attrs['name'], tag.attrs['content'].lower())
                results.update(
                    {tag.attrs['name'].lower(): str(tag.attrs['content'])})
            elif 'property' in tag.attrs.keys() and tag.attrs['property'].strip().lower() in tags:
                # print(tag.attrs['property'], '          :',
                #       tag.attrs['content'].lower())
                results.update(
                    {tag.attrs['property'].lower(): str(tag.attrs['content'])})
        except Exception as e:
            print('\n\nERROR:', e)

    return results


def formatUrl(url):
    """Convert url to http:// if not present."""
    if not url.startswith('http'):
        url = 'http://' + url
    return url


def tagList():
    """List of tags to be extracted."""
    return [
        'description',
        'url',
        'content-type',
        # FACEBOOK
        'og:topic',
        'og:description',
        'og:image',
        'og:url',
        # TWITTER
        'twitter:card',
        'twitter:site',
        'twitter:topic',
        'twitter:description',
        'twitter:image',
        # BASIC
        'application-name',
    ]

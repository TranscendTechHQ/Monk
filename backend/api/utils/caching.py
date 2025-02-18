"""Basic connection example.
"""


from config import system_cache

def set_cache(key, value):
    system_cache.set(key, value)

def get_cache(key):
    return system_cache.get(key)

def main():
    set_cache('foo', 'bar')
    # True
    result = get_cache('foo')
    print(result)
    # >>> bar


if __name__ == "__main__":
    main()

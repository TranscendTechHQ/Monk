try:
    # Code that may raise an exception
    raise ValueError("An error occurred")
except ValueError as e:
    # Handle the exception
    print(f"Caught an exception: {e}")
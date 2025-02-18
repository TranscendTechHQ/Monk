/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */
import { createSignal, createEffect } from 'solid-js';

const ImageFetcher = () => {
  const [imageUrl, setImageUrl] = createSignal('');
  const presignedUrl = 'YOUR_PRESIGNED_URL_HERE';

  createEffect(() => {
    fetch(presignedUrl)
      .then(response => response.blob())
      .then(blob => {
        const objectUrl = URL.createObjectURL(blob);
        setImageUrl(objectUrl);
      })
      .catch(error => console.error('Error fetching image:', error));
  });

  return (
    <div>
      {imageUrl() ? (
        <img src={imageUrl()} alt="Fetched image" />
      ) : (
        <p>Loading image...</p>
      )}
    </div>
  );
};

export default ImageFetcher;

/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */
import { createSignal } from 'solid-js';

const ImageUploader = () => {
  const [uploadStatus, setUploadStatus] = createSignal('');
  const presignedUrl = 'YOUR_PRESIGNED_URL_HERE';

  const handleFileUpload = async (event: Event) => {
    const file = (event.currentTarget as HTMLInputElement).files?.[0];
    if (!file) return;

    setUploadStatus('Uploading...');

    try {
      const response = await fetch(presignedUrl, {
        method: 'PUT',
        body: file,
        headers: {
          'Content-Type': file.type,
        },
      });

      if (response.ok) {
        setUploadStatus('Upload successful!');
      } else {
        setUploadStatus('Upload failed.');
      }
    } catch (error) {
      console.error('Error uploading file:', error);
      setUploadStatus('Upload failed.');
    }
  };

  return (
    <div>
      <input type="file" onChange={handleFileUpload} accept="image/*" />
      <p>{uploadStatus()}</p>
    </div>
  );
};

export default ImageUploader;

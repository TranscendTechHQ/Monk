import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";

import axios from "axios";



export const fetchImage = async (presigned_url: string): Promise<string> => {
  try {
    

    const response = await fetch(presigned_url, {
      mode: 'cors',
      headers: {
        'Origin': window.location.origin,
        'Access-Control-Allow-Origin': '*'
      }
    });
  
    console.log("response", response);

    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
    
    const blob = await response.blob();
    const objectUrl = URL.createObjectURL(blob);

    return objectUrl;
  } catch (error) {
    console.error('Error fetching image:', error);
    throw error;
  }
}; 

export const uploadImage = async (file: File, presignedUrl: string): Promise<string> => {
  try {
    const response = await fetch(presignedUrl, {
      method: 'PUT',
      body: file,
      headers: {
        'Content-Type': file.type,
      },
    });

    if (response.ok) {
      return 'Upload successful!';
    } else {
      return 'Upload failed.';
    }
  } catch (error) {
    console.error('Error uploading file:', error);
    throw error;
  }
}; 

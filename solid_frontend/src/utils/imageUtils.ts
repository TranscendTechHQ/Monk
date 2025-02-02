import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import axios from "axios";

async function downloadAndDisplayImage(bucketName: string, ImageUrl: string): Promise<Response> {
  console.log("bucketName", bucketName);
  console.log("ImageUrl", ImageUrl);


const url = new URL(ImageUrl);
const key = decodeURIComponent(url.pathname.substring(1)); 
console.log("key", key);
  const client = new S3Client({
    region: "auto",
    endpoint: import.meta.env.VITE_CLOUDFLARE_ENDPOINT,
    credentials: {
      accessKeyId: import.meta.env.VITE_CLOUDFLARE_ACCESS_KEY_ID!,
      secretAccessKey: import.meta.env.VITE_CLOUDFLARE_ACCESS_KEY!,
    },
    forcePathStyle: true
  });

  const command = new GetObjectCommand({
    Bucket: bucketName,
    Key: key,
  });

  const signedUrl = await getSignedUrl(client, command, { expiresIn: 3600 });

  const response = await fetch(signedUrl, {
    mode: 'cors',
    headers: {
      'Origin': window.location.origin,
      'Access-Control-Allow-Origin': '*'
    }
  });

  console.log("response", response);
  return response;
  
  // Remember to revoke the object URL when you're done with it
  // URL.revokeObjectURL(objectUrl);
}





export const fetchImage = async (url: string): Promise<string> => {
  try {
    const response = await downloadAndDisplayImage("monk-assets", url );
    
    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
    
    const blob = await response.blob();
    const objectUrl = URL.createObjectURL(blob);

  // Create an img element and set its src to the object URL
 // const img = document.createElement('img');
  //img.src = objectUrl;
  //document.body.appendChild(img);

    //const blob = await response.blob();
    return objectUrl;
  } catch (error) {
    console.error('Error fetching image:', error);
    throw error;
  }
}; 

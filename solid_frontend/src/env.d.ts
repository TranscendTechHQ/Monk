/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */
/// <reference types="vite/client" />

interface ImportMetaEnv {
    readonly VITE_CLOUDFLARE_ENDPOINT: string;
    readonly VITE_CLOUDFLARE_ACCESS_KEY_ID: string;
    readonly VITE_CLOUDFLARE_ACCESS_KEY: string;
  }
  
  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }
  
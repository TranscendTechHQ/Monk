/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

/**
 * Base configuration for API requests
 */
const API_BASE_URL = 'http://localhost:8001';

/**
 * Types for API responses
 */
export interface Thread {
  id: string;
  blocks: ThreadBlock[];
  created_at: string;
  updated_at: string;
}

export interface ThreadBlock {
  id: string;
  content: string;
  thread_id: string;
  position: number;
}

/**
 * API client for handling thread-related operations
 */
export class ApiClient {
  private static async fetchWithError(url: string, options: RequestInit = {}) {
    const response = await fetch(`${API_BASE_URL}${url}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  public static async getThreads(): Promise<Thread[]> {
    return this.fetchWithError('/threads');
  }

  public static async createThread(blocks: { content: string }[]): Promise<Thread> {
    return this.fetchWithError('/threads', {
      method: 'POST',
      body: JSON.stringify({ blocks }),
    });
  }

  public static async updateThread(threadId: string, blocks: { content: string }[]): Promise<Thread> {
    return this.fetchWithError(`/threads/${threadId}`, {
      method: 'PUT',
      body: JSON.stringify({ blocks }),
    });
  }
} 
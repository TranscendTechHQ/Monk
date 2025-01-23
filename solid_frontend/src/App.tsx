/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createSignal, createEffect, For } from 'solid-js';
import UserInfo from './components/UserInfo';

import { ThreadList } from './components/Thread';

import { ThreadsService } from './api/services/ThreadsService';
import { OpenAPI } from './api/core/OpenAPI';
import { ThreadMetaData, ThreadsMetaData } from './api';
OpenAPI.BASE = 'http://localhost:8001';


const App: Component = () => {
  const [threads, setThreads] = createSignal<ThreadsMetaData>();
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);

  const fetchThreads = async () => {
    try {
      setIsLoading(true);
      const fetchedThreads = await ThreadsService.filterNewsfeedGet();
      setThreads(fetchedThreads);
      setError(null);
    } catch (err) {
      setError('Failed to load threads. Please try again later.');
      console.error('Error fetching threads:', err);
    } finally {
      setIsLoading(false);
    }
  };

  // Fetch threads on component mount
  createEffect(() => {
    fetchThreads();
  });

  return (
    <div class="relative min-h-screen">
      <div class="min-h-screen bg-slate-900">
        <header class="bg-slate-800 py-6 px-4 border-b border-slate-700">
          <h1 class="text-white text-3xl font-semibold text-center">Thread Feed</h1>
        </header>

        <main class="py-12">
          <div class="container mx-auto">
            <h2 class="text-center text-xl font-medium text-white mb-6">All Threads</h2>
            
            <div class="flex flex-col items-center gap-6">
              {isLoading() ? (
                <div class="text-center text-slate-300">Loading threads...</div>
              ) : error() ? (
                <div class="text-center text-red-400">{error()}</div>
              ) : (
                <ThreadList threads={threads()?.metadata || []} />
              )}
            </div>
          </div>
        </main>
      </div>
      <UserInfo />
    </div>
  );
};

export default App;
 
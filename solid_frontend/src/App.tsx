/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createSignal, createEffect, For } from 'solid-js';
import UserInfo from './components/UserInfo';
import { ThreadList } from './components/Thread';
import { ThreadsService } from './api/services/ThreadsService';
import { OpenAPI } from './api/core/OpenAPI';
import { ThreadMetaData, ThreadsMetaData, ThreadsModel } from './api';
OpenAPI.BASE = 'http://localhost:8001';

const App: Component = () => {
  const [threads, setThreads] = createSignal<ThreadsMetaData>();
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [searchQuery, setSearchQuery] = createSignal<string>('');
  const [searchResults, setSearchResults] = createSignal<ThreadsModel>();

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

  const searchThreads = async () => {
    if (searchQuery().trim() === '') {
      setSearchResults(undefined);
      return;
    }
    try {
      const results = await ThreadsService.searchThreadsSearchThreadsGet(searchQuery());
      setSearchResults(results);
    } catch (err) {
      console.error('Error searching threads:', err);
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
            <div class="flex flex-col items-center gap-6">
              {isLoading() ? (
                <div class="text-center text-slate-300">Loading threads...</div>
              ) : error() ? (
                <div class="text-center text-red-400">{error()}</div>
              ) : (
                <>
                  <ThreadList threads={threads()?.metadata || []} />
                  
                  <div class="flex justify-center mb-6">
                    <input
                      type="text"
                      value={searchQuery()}
                      onInput={(e) => setSearchQuery(e.currentTarget.value)}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter') {
                          searchThreads();
                        }
                      }}
                      class="border border-slate-600 bg-slate-700 text-white p-2 rounded w-1/2"
                      placeholder="Search threads..."
                    />
                  </div>

                  {(searchResults()?.threads ?? []).length > 0 && (
  <div class="mt-6">
    <h2 class="text-white text-xl font-semibold">Search Results:</h2>
    <For each={searchResults()?.threads ?? []}>
      {(thread) => (
        <div id={thread._id?.toString() ?? ''} class="bg-slate-800 p-4 rounded-lg shadow-md mt-4">
          <h3 class="text-white text-lg font-semibold">{thread.topic}</h3>
          <p class="text-slate-300 mt-2">{thread.headline || "No Title"}</p>
        </div>
      )}
    </For>
  </div>
)}


                </>
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
 
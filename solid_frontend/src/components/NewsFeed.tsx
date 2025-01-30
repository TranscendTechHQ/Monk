import { Component, createSignal, createEffect, For } from 'solid-js';
import { ThreadList } from './Thread';
import { ThreadsService } from '../api/services/ThreadsService';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import UserInfo from './UserInfo';

const NewsFeed: Component = () => {
  const [threads, setThreads] = createSignal<ThreadsResponse>();
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [searchQuery, setSearchQuery] = createSignal<string>('');
  const [searchResults, setSearchResults] = createSignal<ThreadsResponse>();

  const fetchThreads = async () => {
    try {
      setIsLoading(true);
      const fetchedThreads = await ThreadsService.getThreads();
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

  const clearSearch = () => {
    setSearchQuery('');
    setSearchResults(undefined);
  };

  createEffect(() => {
    fetchThreads();
  });

  return (
    <div class="min-h-screen bg-slate-900">
      <main class="py-12">
        <div class="container mx-auto h-[600px]">
          <div class="bg-slate-800 rounded-xl p-8 shadow-xl max-w-4xl mx-auto h-full">
            <h2 class="text-white text-3xl font-bold mb-8 text-center">NewsFeed</h2>
            {isLoading() ? (
              <div class="text-center text-slate-300">Loading threads...</div>
            ) : error() ? (
              <div class="text-center text-red-400">{error()}</div>
            ) : (
              <div class="flex flex-col items-center gap-6 h-[calc(100%-96px)]">
                <div class="w-full space-y-4 overflow-y-auto max-h-[400px]">
                  <ThreadList threads={{ threads: threads()?.threads || [] }} />
                </div>
                
                {/* Search components and results */}
                <div class="flex justify-center mb-6 w-1/2">
                  <input
                    type="text"
                    value={searchQuery()}
                    onInput={(e) => setSearchQuery(e.currentTarget.value)}
                    onKeyDown={(e) => e.key === 'Enter' && searchThreads()}
                    class="border border-slate-600 bg-slate-700 text-white p-2 rounded w-full"
                    placeholder="Search threads..."
                  />
                  <button
                    onClick={searchThreads}
                    class="ml-2 bg-slate-600 text-white py-2 px-4 rounded hover:bg-slate-500 transition duration-200"
                  >
                    Submit
                  </button>
                  <button
                    onClick={clearSearch}
                    class="ml-2 bg-red-600 text-white py-2 px-4 rounded hover:bg-red-500 transition duration-200"
                  >
                    Clear
                  </button>
                </div>

                {(searchResults()?.threads ?? []).length > 0 && (
                  <div class="w-full mt-4">
                    <h2 class="text-white text-xl font-semibold mb-4 text-center">Search Results</h2>
                    <div class="space-y-4 overflow-y-auto max-h-[300px]">
                      <For each={searchResults()?.threads ?? []}>
                        {(thread) => (
                          <div id={thread.id?.toString() ?? ''} class="bg-slate-700 p-4 rounded-lg shadow-md mt-4">
                            <h3 class="text-white text-lg font-semibold">{thread.content.topic}</h3>
                            <p class="text-slate-300 mt-2">{thread.content.headline?.toString() || "No Title"}</p>
                          </div>
                        )}
                      </For>
                    </div>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </main>
      <UserInfo />
    </div>
  );
};

export default NewsFeed; 
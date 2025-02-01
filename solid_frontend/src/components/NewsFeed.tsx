import { Component, createSignal, createEffect, For, Show } from 'solid-js';
import { ThreadList } from './Thread';
import { ThreadsService } from '../api/services/ThreadsService';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import UserInfo from './UserInfo';

import { userService } from '../services/userService';
import { useNavigate } from '@solidjs/router';

const SearchModal: Component<{ 
  results: ThreadsResponse, 
  onClose: () => void,
  navigate: (path: string) => void 
}> = (props) => {
  return (
    <div class="fixed inset-0 bg-monk-dark/90 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-monk-blue/90 backdrop-blur-lg rounded-xl p-6 w-full max-w-2xl">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-monk-cream text-xl font-bold">Search Results</h3>
          <button
            onClick={props.onClose}
            class="text-monk-gray hover:text-monk-gold transition-colors"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div class="space-y-4">
          <For each={props.results.threads}>
            {(thread) => (
              <div 
                class="bg-monk-mid/70 backdrop-blur-sm p-4 rounded-xl border-2 border-monk-red
                       hover:border-monk-red/90 hover:bg-monk-mid/90 transition-all cursor-pointer
                       shadow-lg hover:shadow-xl"
                onClick={() => {
                  props.navigate(`/thread/${thread._id}?thread_topic=${thread.topic}`);
                  props.onClose();
                }}
              >
                <h3 class="text-monk-cream text-lg font-semibold">{thread.topic}</h3>
                <p class="text-monk-gray mt-2">By {userService.getUserName(thread.creator_id ?? 'unknown')}</p>
              </div>
            )}
          </For>
        </div>
      </div>
    </div>
  );
};

const NewsFeed: Component = () => {
  const [threads, setThreads] = createSignal<ThreadsResponse>();
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [searchQuery, setSearchQuery] = createSignal<string>('');
  const [searchResults, setSearchResults] = createSignal<ThreadsResponse>();
  const [showSearchModal, setShowSearchModal] = createSignal(false);
  const [isUserCacheReady, setIsUserCacheReady] = createSignal(false);
  const [isSearching, setIsSearching] = createSignal(false);
  const navigate = useNavigate();

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
      setIsSearching(true);
      const results = await ThreadsService.searchThreads(searchQuery());
      setSearchResults(results);
      setShowSearchModal(true);
    } catch (err) {
      console.error('Error searching threads:', err);
    } finally {
      setIsSearching(false);
    }
  };

  const clearSearch = () => {
    setSearchQuery('');
    setSearchResults(undefined);
  };

  createEffect(async () => {
    try {
      await userService.initialize();
      setIsUserCacheReady(true);
    } catch (err) {
      console.error('User cache initialization failed:', err);
    }
  });

  createEffect(() => {
    fetchThreads();
  });

  return (
    <div class="min-h-screen bg-gradient-to-br from-monk-dark via-monk-mid to-monk-light">
      <Show when={isUserCacheReady()}>
        <main class="py-12">
          <div class="container mx-auto h-[600px]">
            <div class="flex flex-col h-[calc(100vh-100px)]">
              {/* Search Bar */}
              <div class="sticky top-0 bg-monk-dark/95 backdrop-blur-sm z-10 pt-4 pb-6 px-8">
                <div class="flex items-center gap-4 max-w-4xl mx-auto">
                  <h2 class="text-monk-cream text-3xl font-bold">NewsFeed</h2>
                  <div class="flex-1 flex gap-2">
                    <input
                      type="text"
                      value={searchQuery()}
                      onInput={(e) => setSearchQuery(e.currentTarget.value)}
                      onKeyDown={(e) => e.key === 'Enter' && searchThreads()}
                      class="flex-1 border-2 border-monk-gold/30 bg-monk-dark text-white p-3 rounded-xl
                             focus:outline-none focus:ring-2 focus:ring-monk-gold focus:border-transparent
                             placeholder-monk-gray"
                      placeholder="Search threads..."
                    />
                    <button
                      onClick={searchThreads}
                      disabled={isSearching()}
                      class="bg-monk-gold text-monk-blue px-6 py-3 rounded-lg hover:bg-monk-orange transition-colors
                             font-semibold min-w-[100px]"
                    >
                      {isSearching() ? '...' : 'Search'}
                    </button>
                    <button
                      onClick={clearSearch}
                      class="bg-monk-red text-monk-cream px-4 py-3 rounded-lg hover:bg-monk-red/80 transition-colors"
                    >
                      Clear
                    </button>
                  </div>
                </div>
              </div>

              {/* Scrollable Thread List */}
              <div class="flex-1 overflow-y-auto px-8 pb-8">
                <div class="max-w-4xl mx-auto">
                  <ThreadList threads={{ threads: threads()?.threads || [] }} />
                </div>
              </div>
            </div>
          </div>
        </main>
        <UserInfo />
      </Show>
      <Show when={!isUserCacheReady()}>
        <div class="text-center text-monk-gray p-8">Loading user data...</div>
      </Show>
    </div>
  );
};

export default NewsFeed; 
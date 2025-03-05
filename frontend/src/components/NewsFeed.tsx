import { Component, createSignal, createEffect, For, Show } from 'solid-js';
import { ThreadList } from './Thread';
import { ThreadsService } from '../api/services/ThreadsService';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import { userService } from '../services/userService';
import { useNavigate } from '@solidjs/router';
import SearchModal from './SearchModal';
import NewThreadModal from './NewThreadModal';
import Header from './Header';

const NewsFeed: Component = () => {
  const [threads, setThreads] = createSignal<ThreadsResponse>();
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [searchQuery, setSearchQuery] = createSignal<string>('');
  const [searchResults, setSearchResults] = createSignal<ThreadsResponse>();
  const [showSearchModal, setShowSearchModal] = createSignal(false);
  const [isUserCacheReady, setIsUserCacheReady] = createSignal(false);
  const [isSearching, setIsSearching] = createSignal(false);
  const [showNewThreadModal, setShowNewThreadModal] = createSignal(false);
  const navigate = useNavigate();

  const fetchThreads = async () => {
    try {
      setIsLoading(true);
      const fetchedThreads = await ThreadsService.getThreads();
      setThreads(fetchedThreads);
      setError(null);
    } catch (err) {
      console.error('Error fetching threads:', err);
      setError('Failed to load threads. Please try again later.');
    } finally {
      setIsLoading(false);
    }
  };

  const searchThreads = async () => {
    if (!searchQuery().trim()) return;
    
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
      // The userService.initialize() is already called in App.tsx
      // and now checks for authentication internally
      // We'll just set the cache as ready since it will be initialized if the user is authenticated
      setIsUserCacheReady(true);
    } catch (err) {
      console.error('User cache initialization failed:', err);
    }
  });

  createEffect(() => {
    fetchThreads();
  });

  return (
    <div class="h-screen flex flex-col bg-slate-900 text-white">
      <Header />
      
      {/* Main content area with fixed header and scrollable content */}
      <div class="flex-1 overflow-hidden flex flex-col">
        {/* Fixed action bar */}
        <div class="bg-slate-800 p-4 shadow-md">
          <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">News Feed</h1>
            <div class="flex space-x-2">
              <button
                onClick={() => setShowSearchModal(true)}
                class="bg-slate-700 hover:bg-slate-600 text-white px-4 py-2 rounded transition-colors"
              >
                Search
              </button>
              <button
                onClick={() => setShowNewThreadModal(true)}
                class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition-colors"
              >
                New Thread
              </button>
            </div>
          </div>
        </div>
        
        {/* Scrollable content area */}
        <div class="flex-1 overflow-y-auto p-4">
          <div class="container mx-auto">
            <Show when={!isLoading()} fallback={<div class="text-center py-8">Loading threads...</div>}>
              <Show when={!error()} fallback={<div class="text-red-500">{error()}</div>}>
                <Show
                  when={searchResults() || threads()}
                  fallback={<div class="text-center py-8">No threads found</div>}
                >
                  <ThreadList 
                    threads={searchResults() || threads() || { threads: [] }} 
                  />
                </Show>
              </Show>
            </Show>
          </div>
        </div>
      </div>

      <Show when={showSearchModal() && searchResults()}>
        <SearchModal
          results={searchResults()!}
          onClose={() => setShowSearchModal(false)}
          navigate={navigate}
        />
      </Show>

      <Show when={showNewThreadModal()}>
        <NewThreadModal
          show={showNewThreadModal()}
          onClose={() => setShowNewThreadModal(false)}
          onSuccess={fetchThreads}
        />
      </Show>
    </div>
  );
};

export default NewsFeed; 
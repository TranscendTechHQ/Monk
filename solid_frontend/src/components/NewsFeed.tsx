import { Component, createSignal, createEffect, For, Show } from 'solid-js';
import { ThreadList } from './Thread';
import { ThreadsService } from '../api/services/ThreadsService';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import UserInfo from './UserInfo';

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
    <>
      <div class="h-screen flex flex-col">
        <Header />
        {/* Main Content Area */}
        <div class="flex-1 overflow-hidden">
          {/* Search Header */}
          <div class="h-[120px] sticky top-0 bg-monk-dark/95 backdrop-blur-sm z-10 pt-4 pb-6 px-8">
            <div class="flex items-center gap-4 max-w-4xl mx-auto">
              
              <div class="flex-1 flex gap-4">
                <button
                  onClick={() => setShowNewThreadModal(true)}
                  class="bg-monk-purple text-monk-cream px-6 py-3 rounded-full 
                         hover:bg-monk-purple/80 transition-all font-bold
                         border-2 border-monk-pink shadow-lg hover:shadow-monk-pink/50
                         transform hover:scale-105"
                >
                  New Thread
                </button>
                <input
                  type="text"
                  name="search bar"
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
          <div class="h-[calc(100vh-200px)] overflow-y-auto" >


          <div class="max-w-4xl mx-auto">

              <Show when={!isLoading() && !error()}>
                <ThreadList threads={{ threads: threads()?.threads || [] }} />
              </Show>
            </div>
          </div>
        </div>

        {/* Fixed Footer */}
        <div class="h-[80px] border-t border-monk-teal/20 bg-monk-dark/95 backdrop-blur-sm">
          <UserInfo />
        </div>
      </div>

      {/* Search Modal */}
      <Show when={showSearchModal() && searchResults()?.threads?.length}>
        <SearchModal 
          results={searchResults()!} 
          onClose={() => setShowSearchModal(false)}
          navigate={navigate}
        />
      </Show>

      <NewThreadModal 
        show={showNewThreadModal()}
        onClose={() => setShowNewThreadModal(false)}
        onSuccess={fetchThreads}
      />
    </>
  );
};

export default NewsFeed; 
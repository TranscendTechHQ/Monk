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

const NewThreadModal: Component<{
  show: boolean;
  topic: string;
  text: string;
  image: File | null;
  imagePreview: string | null;
  isCreating: boolean;
  onClose: () => void;
  setTopic: (v: string) => void;
  setText: (v: string) => void;
  setImage: (f: File | null) => void;
  setImagePreview: (v: string | null) => void;
  onCreate: () => void;
  onSuccess: () => void;
}> = (props) => {
  const handleCreateThread = async () => {
    if (!props.topic.trim() && !props.text.trim() && !props.image) return;

    try {
      props.onCreate();
      let imageKey = null;
      
      if (props.image) {
        imageKey = props.image.name;
        const presigned_url  = await ThreadsService.getUploadUrl(imageKey);
        
        await fetch(presigned_url, {
          method: 'PUT',
          body: props.image,
          headers: {
            'Content-Type': props.image.type,
          }
        });
      }

      await ThreadsService.createThread({
        topic: props.topic,
        text: props.text,
        image: imageKey || undefined
      });

      props.onClose();
      props.onSuccess();
    } catch (err) {
      console.error('Error creating thread:', err);
    }
  };

  return (
    <div class="fixed inset-0 bg-monk-dark/90 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-monk-blue/90 backdrop-blur-lg rounded-xl p-6 w-full max-w-2xl">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-monk-cream text-xl font-bold">Create New Thread</h3>
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
          <input
            type="text"
            value={props.topic}
            onInput={(e) => props.setTopic(e.currentTarget.value)}
            placeholder="Thread Topic"
            class="w-full bg-monk-dark text-monk-cream p-3 rounded-lg border border-monk-teal/40 focus:outline-none focus:border-monk-teal"
          />

          <div class="flex items-center gap-2 border border-monk-teal/40 rounded-lg p-2">
            <label class="cursor-pointer text-monk-gray hover:text-monk-gold transition-colors">
              <input
                type="file"
                accept="image/*"
                class="hidden"
                onChange={(e) => {
                  const file = e.currentTarget.files?.[0];
                  if (file) {
                    props.setImage(file);
                    props.setImagePreview(URL.createObjectURL(file));
                  }
                }}
              />
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
              </svg>
            </label>

            <textarea
              value={props.text}
              onInput={(e) => props.setText(e.currentTarget.value)}
              placeholder="Start your discussion..."
              class="flex-1 bg-transparent text-monk-cream p-2 focus:outline-none h-32 resize-none"
            />
          </div>

          <Show when={props.imagePreview}>
            <div class="relative">
              <img 
                src={props.imagePreview!} 
                alt="Preview" 
                class="max-h-48 w-auto rounded-lg"
              />
              <button
                onClick={() => {
                  props.setImage(null);
                  props.setImagePreview(null);
                }}
                class="absolute top-1 right-1 bg-monk-red/80 text-white rounded-full p-1 hover:bg-monk-red"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            </div>
          </Show>

          <button
            onClick={handleCreateThread}
            disabled={props.isCreating}
            class="w-full bg-monk-gold text-monk-blue py-3 rounded-lg hover:bg-monk-orange transition-colors disabled:opacity-50"
          >
            {props.isCreating ? 'Creating...' : 'Create Thread'}
          </button>
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
  const [showNewThreadModal, setShowNewThreadModal] = createSignal(false);
  const [newThreadTopic, setNewThreadTopic] = createSignal('');
  const [newThreadText, setNewThreadText] = createSignal('');
  const [newThreadImage, setNewThreadImage] = createSignal<File | null>(null);
  const [newThreadImagePreview, setNewThreadImagePreview] = createSignal<string | null>(null);
  const [isCreatingThread, setIsCreatingThread] = createSignal(false);
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

  const handleCreateThread = async () => {
    // This should be empty or contain only state management
    // The actual API call should happen in the modal's handleCreateThread
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
        {/* Main Content Area */}
        <div class="flex-1 overflow-hidden">
          {/* Search Header */}
          <div class="h-[120px] sticky top-0 bg-monk-dark/95 backdrop-blur-sm z-10 pt-4 pb-6 px-8">
            <div class="flex items-center gap-4 max-w-4xl mx-auto">
              <h2 class="text-monk-cream text-3xl font-bold">NewsFeed</h2>
              <div class="flex-1 flex gap-4">
                <button
                  onClick={() => setShowNewThreadModal(true)}
                  class="bg-monk-gold text-monk-blue px-6 py-3 rounded-lg hover:bg-monk-orange transition-colors font-semibold"
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

      <Show when={showNewThreadModal()}>
        <NewThreadModal 
          show={showNewThreadModal()}
          topic={newThreadTopic()}
          text={newThreadText()}
          image={newThreadImage()}
          imagePreview={newThreadImagePreview()}
          isCreating={isCreatingThread()}
          onClose={() => setShowNewThreadModal(false)}
          setTopic={setNewThreadTopic}
          setText={setNewThreadText}
          setImage={setNewThreadImage}
          setImagePreview={setNewThreadImagePreview}
          onCreate={handleCreateThread}
          onSuccess={fetchThreads}
        />
      </Show>
    </>
  );
};

export default NewsFeed; 
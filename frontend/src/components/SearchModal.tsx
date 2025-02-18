import { Component } from 'solid-js';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import { userService } from '../services/userService';

interface SearchModalProps {
  results: ThreadsResponse;
  onClose: () => void;
  navigate: (path: string) => void;
}

const SearchModal: Component<SearchModalProps> = (props) => {
  return (
    <div class="fixed inset-0 bg-monk-dark/90 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-monk-blue/90 backdrop-blur-lg rounded-xl p-6 w-full max-w-2xl">
        {/* Existing SearchModal JSX */}
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
  );
};

export default SearchModal; 
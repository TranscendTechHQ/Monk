import { Component, createSignal, onMount, createMemo, createEffect } from 'solid-js';
import { useParams, useNavigate, useLocation } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';
import { MessagesResponse } from '../api/models/MessagesResponse';
import { MessageCreate } from '../api/models/MessageCreate';
import { MessageResponse } from '../api/models/MessageResponse';
import UserInfo from './UserInfo';


import { userService } from '../services/userService';

const ThreadMessages: Component = () => {
  const params = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const threadTopic = new URLSearchParams(location.search).get('thread_topic');
  console.log("thread topic = ", threadTopic);
  const [thread, setThread] = createSignal<MessagesResponse | null>(null);
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [newMessage, setNewMessage] = createSignal<string>('');
  const [userCache, setUserCache] = createSignal<Record<string, string>>({});

  const fetchThreadMessages = async () => {
    setIsLoading(true);
    try {
      const threadId = params.id;
      
      const fetchedThread = await ThreadsService.getMessages(threadId);
      setThread(fetchedThread);
      setError(null);
    } catch (err) {
      setError('Failed to load thread messages. Please try again later.');
      console.error('Error fetching thread messages:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleNewMessageKeyDown = async (event: KeyboardEvent) => {
    if (event.key === 'Enter' && newMessage().trim() !== '') {
      try {
        const threadId = params.id;
        const new_message: MessageCreate = {
          text: newMessage(),
          thread_id: threadId
        };
        await ThreadsService.createMessage(new_message);
        setNewMessage('');
        fetchThreadMessages();
      } catch (err) {
        console.error('Error creating message:', err);
      }
    }
  };

  onMount(() => {
    fetchThreadMessages();
  });

  const messages = createMemo(() => thread()?.messages || []);

  return (
    <div class="h-screen flex flex-col bg-monk-dark">
      {/* Header */}
      <div class="h-[120px] sticky top-0 bg-monk-dark/95 backdrop-blur-sm z-10 pt-4 pb-6 px-8">
        <h2 class="text-monk-cream text-3xl font-bold text-center">{params.thread_topic}</h2>
      </div>

      {/* Messages List */}
      <div class="flex-1 overflow-y-auto pb-4">
        <div class="max-w-4xl mx-auto px-8 pt-4 space-y-4">
          <For each={messages()}>
            {(message) => (
              <div class="bg-monk-mid/70 backdrop-blur-sm p-4 rounded-xl border-2 border-monk-teal/40
                         hover:border-monk-teal/60 transition-colors">
                <p class="text-monk-cream">{message.text}</p>
                <div class="mt-2 text-monk-gray text-sm">
                  <span>By {userService.getUserName(message.creator_id)} • 
                    {new Date(message.created_at).toLocaleString()}
                  </span>
                </div>
              </div>
            )}
          </For>
        </div>
      </div>

      {/* Footer */}
      <div class="h-[120px] border-t border-monk-teal/20 bg-monk-dark/95 backdrop-blur-sm">
        <div class="max-w-4xl mx-auto px-8 pt-4 flex items-center gap-4">
          <button 
            onClick={() => navigate(-1)}
            class="text-monk-gray hover:text-monk-gold transition-colors"
          >
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
            </svg>
          </button>

          <input
            type="text"
            value={newMessage()}
            onInput={(e) => setNewMessage(e.currentTarget.value)}
            onKeyDown={handleNewMessageKeyDown}
            class="flex-1 border-2 border-monk-gold/30 bg-monk-dark text-white p-3 rounded-xl
                   focus:outline-none focus:ring-2 focus:ring-monk-gold focus:border-transparent
                   placeholder-monk-gray"
            placeholder="Type your message..."
          />

          <button 
            onClick={async () => {
              if (newMessage().trim()) {
                try {
                  await ThreadsService.createMessage({
                    text: newMessage(),
                    thread_id: params.id
                  });
                  setNewMessage('');
                  await fetchThreadMessages();
                } catch (err) {
                  console.error('Error creating message:', err);
                }
              }
            }}
            class="bg-monk-gold text-monk-blue px-6 py-3 rounded-lg hover:bg-monk-orange transition-colors"
          >
            Send
          </button>
        </div>

        <div class="max-w-4xl mx-auto px-8 pt-2 flex justify-start">
          <UserInfo />
        </div>
      </div>
    </div>
  );
};

export default ThreadMessages; 
import { Component, createSignal, onMount, createMemo, createEffect } from 'solid-js';
import { useParams, useNavigate } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';
import { MessagesResponse } from '../api/models/MessagesResponse';
import { MessageCreate } from '../api/models/MessageCreate';
import { MessageResponse } from '../api/models/MessageResponse';
import UserInfo from './UserInfo';
import { UserMap } from '../api/models/UserMap';
import { getUserName } from '../utils/userUtils';

const ThreadMessages: Component = () => {
  const params = useParams();
  const navigate = useNavigate();
  const [thread, setThread] = createSignal<MessagesResponse | null>(null);
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [newMessage, setNewMessage] = createSignal<string>('');
  const [userCache, setUserCache] = createSignal<Record<string, string>>({});

  const fetchThreadDetails = async () => {
    setIsLoading(true);
    try {
      const threadId = params.id;
      const fetchedThread = await ThreadsService.getMessages(threadId);
      setThread(fetchedThread);
      setError(null);
    } catch (err) {
      setError('Failed to load thread details. Please try again later.');
      console.error('Error fetching thread details:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleNewMessageKeyDown = async (event: KeyboardEvent) => {
    if (event.key === 'Enter' && newMessage().trim() !== '') {
      try {
        const threadId = params.id;
        const new_message: MessageCreate = {
          content: { text: newMessage() },
          thread_id: threadId
        };
        await ThreadsService.createMessage(new_message);
        setNewMessage('');
        fetchThreadDetails();
      } catch (err) {
        console.error('Error creating message:', err);
      }
    }
  };

  onMount(() => {
    fetchThreadDetails();
  });

  const messages = createMemo(() => thread()?.messages || []);

  // Add this effect to handle user cache updates
  createEffect(() => {
    if (thread()) {
      // Ensure user cache is initialized
      getUserName(thread()!.creator_id);
    }
  });

  return (
    <div class="min-h-screen bg-slate-900">
      <main class="py-12">
        <div class="container mx-auto h-[600px]">
          <div class="bg-slate-800 rounded-xl p-8 shadow-xl max-w-4xl mx-auto h-full">
            {/* Header and message list */}
            <div class="flex items-center justify-center mb-8 relative">
              <button 
                onClick={() => navigate('/')}
                class="bg-slate-600 text-white py-2 px-4 rounded hover:bg-slate-500 transition duration-200 flex items-center absolute left-0"
              >
                {/* Back button SVG */}
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                NewsFeed
              </button>
              <h2 class="text-white text-3xl font-bold text-center">Messages</h2>
            </div>

            {/* Loading and error states */}
            {isLoading() ? (
              <div class="text-slate-300">Loading thread details...</div>
            ) : error() ? (
              <div class="text-red-400">{error()}</div>
            ) : (
              <div class="h-[calc(100%-96px)] flex flex-col">
                {/* Messages list */}
                <div class="space-y-2 overflow-y-auto max-h-[400px] mx-auto w-1/2">
                  {messages().map((message: MessageResponse) => (
                    <div 
                      id={message.id} 
                      class="bg-slate-800 text-white p-4 rounded-lg shadow-md my-2"
                    >
                      <p class="text-slate-100">{message.content.text}</p>
                      <p class="text-slate-300 text-sm mt-1">— {getUserName(message.creator_id)}</p>
                    </div>
                  ))}
                </div>

                {/* New message input */}
                <div class="mt-auto pt-4">
                  <div class="flex justify-center w-1/2 mx-auto">
                    <input 
                      type="text" 
                      value={newMessage()} 
                      onInput={(e) => setNewMessage(e.currentTarget.value)} 
                      onKeyDown={handleNewMessageKeyDown}
                      class="w-full border border-slate-600 bg-slate-700 text-white p-2 rounded focus:outline-none focus:ring focus:ring-slate-500"
                      placeholder="Type your message and press Enter..."
                    />
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </main>
      <UserInfo />
    </div>
  );
};

export default ThreadMessages; 
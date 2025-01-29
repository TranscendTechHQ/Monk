import { Component, createSignal, onMount, createMemo } from 'solid-js';
import { useParams, useNavigate } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';

import { QuillEditor } from './MyQuillEditor';
import { MessagesResponse } from '../api/models/MessagesResponse';
import { MessageCreate } from '../api/models/MessageCreate';
import { Message } from '../api/models/Message';
import { MessageResponse } from '../api/models/MessageResponse';
const ThreadDetail: Component = () => {
  const params = useParams();
  const navigate = useNavigate();
  const [thread, setThread] = createSignal<MessagesResponse | null>(null);
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [newMessage, setNewMessage] = createSignal<string>(''); // State for the new message
  

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
          content: {
            text: newMessage(),
          },
          thread_id: threadId,   // Get the thread ID from the URL
      };
        await ThreadsService.createMessage(new_message); // Create a new message
        setNewMessage(''); // Clear the input after submission
        fetchThreadDetails(); // Refresh the thread details to show the new message
      } catch (err) {
        console.error('Error creating new block:', err);
      }
    }
  };

  onMount(() => {
    fetchThreadDetails();
  });

  const messages = createMemo(() => thread()?.messages || []);

  return (
    <div class="min-h-screen bg-slate-900 p-6">
      <button 
        onClick={() => navigate('/')}
        class="mb-4 bg-slate-600 text-white py-2 px-4 rounded hover:bg-slate-500 transition duration-200"
      >
        Back to Threads
      </button>
      
      {isLoading() ? (
        <div class="text-slate-300">Loading thread details...</div>
      ) : error() ? (
        <div class="text-red-400">{error()}</div>
      ) : (
        <div class="space-y-4">
          <h2 class="text-slate-100 text-2xl text-center font-bold">Thread: </h2>
          <div class="text-slate-300">
            {/*<p>{thread()?.headline || "No Headline"}</p>*/}
            <p class="text-slate-300 text-center">Created by: { "Unknown"}</p>
          </div>
          
          <div class="space-y-2">
            {messages().map((message: MessageResponse) => (
              <div 
                id={message.id} 
                class="bg-slate-800 text-white p-4 rounded-lg shadow-md max-w-[50%] mx-auto my-2"
              >
                <p class="text-slate-100">{message.content.text}</p>
                <p class="text-slate-300 text-sm mt-1">— {message.creator_id || "Unknown"}</p>
              </div>
            ))}
          </div>

          {/* Input box for new message */}
          <div class="mt-4 flex justify-center">
            <input 
              type="text" 
              value={newMessage()} 
              onInput={(e) => setNewMessage(e.currentTarget.value)} 
              onKeyDown={handleNewMessageKeyDown}
              class="w-full max-w-[50%] p-2 rounded border border-slate-600 bg-slate-700 text-white focus:outline-none focus:ring focus:ring-slate-500 mx-auto"
              placeholder="Type your message and press Enter..."
            />
          </div>
          
            <div class="container max-w-[50%] mx-auto">
                <QuillEditor />
            </div>
    
        </div>
      )}
    </div>
  );
};

export default ThreadDetail; 
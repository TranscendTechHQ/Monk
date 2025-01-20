import { Component, createSignal, onMount } from 'solid-js';
import { useParams, useNavigate } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';

import { FullThreadInfo } from '../api/models/FullThreadInfo'; // Adjust based on your structure

import { BlockWithCreator } from '../api/models/BlockWithCreator'; // Adjust the path based on your structure

import { QuillEditor } from './MyQuillEditor';


const ThreadDetail: Component = () => {
  const params = useParams();
  const navigate = useNavigate();
  const [thread, setThread] = createSignal<FullThreadInfo | null>(null);
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [newMessage, setNewMessage] = createSignal<string>(''); // State for the new message
  

  const fetchThreadDetails = async () => {
    try {
      setIsLoading(true);
      const threadId = params.id; // Get the thread ID from the URL
      const fetchedThread = await ThreadsService.getThreadIdThreadsIdGet(threadId); // Fetch thread details
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
        const threadId = params.id; // Get the thread ID from the URL
        await ThreadsService.createBlocksPost(thread()?.topic || "", { content: newMessage(), main_thread_id: threadId }); // Create a new block
        setNewMessage(''); // Clear the input after submission
        fetchThreadDetails(); // Refresh the thread details to show the new block
      } catch (err) {
        console.error('Error creating new block:', err);
      }
    }
  };

  onMount(() => {
    fetchThreadDetails();
  });

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
          <h2 class="text-slate-100 text-2xl text-center font-bold">Thread: {thread()?.topic || "No Topic"}</h2>
          <div class="text-slate-300">
            {/*<p>{thread()?.headline || "No Headline"}</p>*/}
            <p class="text-slate-300 text-center">Created by: {thread()?.creator.name || "Unknown"}</p>
          </div>
          
          <div class="space-y-2">
            {thread()?.content?.map((block: BlockWithCreator) => (
              <div 
                id={block._id} 
                class="bg-slate-800 p-4 rounded-lg shadow-md max-w-[50%] mx-auto"
              >
                <p class="text-slate-100">{block.content}</p>
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
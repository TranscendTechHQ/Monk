import { Component, createSignal, onMount } from 'solid-js';
import { useParams } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';

import { FullThreadInfo } from '../api/models/FullThreadInfo'; // Adjust based on your structure

import { BlockWithCreator } from '../api/models/BlockWithCreator'; // Adjust the path based on your structure

const ThreadDetail: Component = () => {
  const params = useParams();
  const [thread, setThread] = createSignal<FullThreadInfo | null>(null);
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  

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

  onMount(() => {
    fetchThreadDetails();
  });

  return (
    <div class="min-h-screen bg-slate-900 p-6">
      <h1 class="text-white text-3xl font-semibold mb-4">Thread Details</h1>
      {isLoading() ? (
        <div class="text-slate-300">Loading thread details...</div>
      ) : error() ? (
        <div class="text-red-400">{error()}</div>
      ) : (
        <div class="space-y-4">
          <h2 class="text-slate-100 text-2xl font-bold">{thread()?.topic || "No Topic"}</h2>
          <div class="text-slate-300">
            {/*<p>{thread()?.headline || "No Headline"}</p>*/}
            <p>Created by: {thread()?.creator.name || "Unknown"}</p>
          </div>
          <h3 class="text-slate-200 text-lg font-semibold">Blocks:</h3>
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
        </div>
      )}
    </div>
  );
};

export default ThreadDetail; 
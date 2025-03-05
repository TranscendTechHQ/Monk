import { Component, createSignal, onMount, createMemo, createEffect, For, Show } from 'solid-js';
import { useParams, useNavigate, useLocation } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';
import { MessagesResponse } from '../api/models/MessagesResponse';
import { MessageResponse } from '../api/models/MessageResponse';
import { ThreadResponse } from '../api/models/ThreadResponse';

import { userService } from '../services/userService';
import { fetchImage, uploadImage } from '../utils/imageUtils';
import Header from './Header';

const ThreadMessages: Component = () => {
  const params = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const threadTopic = new URLSearchParams(location.search).get('thread_topic') ?? '';
  
  const [thread, setThread] = createSignal<ThreadResponse | null>(null);
  const [messages, setMessages] = createSignal<MessageResponse[]>([]);
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);
  const [newMessage, setNewMessage] = createSignal<string>('');
  const [userCache, setUserCache] = createSignal<Record<string, string>>({});
  const [imageUrls, setImageUrls] = createSignal<Record<string, string>>({});
  const [selectedImage, setSelectedImage] = createSignal<File | null>(null);
  const [imagePreview, setImagePreview] = createSignal<string | null>(null);
  const [isUploading, setIsUploading] = createSignal(false);
  const [imageUrl, setImageUrl] = createSignal<string | null>(null);

  // Add ref for messages container
  let messagesEndRef: HTMLDivElement | undefined;

  const fetchThreadMessages = async () => {
    setIsLoading(true);
    try {
      const [threadData, messagesData] = await Promise.all([
        ThreadsService.getThread(params.id),
        ThreadsService.getMessages(params.id)
      ]);
      setThread(threadData);
      setMessages(messagesData.messages || []);
      setError(null);
    } catch (err) {
      setError('Failed to load thread messages. Please try again later.');
      console.error('Error fetching thread messages:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleNewMessageKeyDown = (event: KeyboardEvent) => {
    if (event.key === 'Enter' && (newMessage().trim() || selectedImage())) {
      handleSend();
    }
  };

  const handleSend = async () => {
    if (!newMessage().trim() && !selectedImage()) return;

    try {
      setIsUploading(true);
      let imageKey = null;
      
      if (selectedImage()) {
        imageKey = selectedImage()!.name;
      }

      const messageResponse = await ThreadsService.createMessage(
        params.id!,
        newMessage().trim(),
        imageKey || undefined
      );
      
      if (messageResponse.presigned_url) {
        await uploadImage(selectedImage()!, messageResponse.presigned_url!);
      }

      // Reset state
      setNewMessage('');
      setSelectedImage(null);
      setImagePreview(null);
      await fetchThreadMessages();
    } catch (err) {
      console.error('Error creating message:', err);
    } finally {
      setIsUploading(false);
    }
  };

  onMount(() => {
    fetchThreadMessages();
  });

  // Create a combined messages array with thread content as first message
  const combinedMessages = createMemo(() => {
    const threadData = thread();
    const messagesList = messages();

    if (!threadData) return messagesList;

    const threadMessage: MessageResponse = {
      _id: threadData._id!,
      text: threadData.text || '',
      image: threadData.image || undefined,
      creator_id: threadData.creator_id!,
      created_at: threadData.created_at!,
      thread_id: threadData._id!,
      presigned_url: imageUrl() || undefined
    };

    return [threadMessage, ...messagesList];
  });

  // Auto-scroll effect
  createEffect(() => {
    if (messagesEndRef && combinedMessages().length > 0) {
      messagesEndRef.scrollIntoView({ behavior: 'smooth' });
    }
  });

  // Add effect to fetch images
  createEffect(async () => {
    const newUrls: Record<string, string> = {};
    for (const message of combinedMessages().filter(m => m.image)) {
      try {
        newUrls[message._id!] = await fetchImage(message.image!);
      } catch (err) {
        console.error('Error loading image:', err);
      }
    }
    setImageUrls(prev => ({ ...prev, ...newUrls }));
  });

  // Fetch thread details
  createEffect(async () => {
    try {
      const threadData = await ThreadsService.getThread(params.id);
      //console.log("thread data = ", threadData);
      setThread(threadData);
      
      if (threadData.image) {
        const url = await ThreadsService.getDownloadUrl(threadData.image);
        setImageUrl(url);
      }
    } catch (err) {
      console.error('Error loading thread:', err);
    }
  });

  return (
    <div class="h-screen flex flex-col bg-slate-900 text-white">
      <Header />
      
      {/* Main content area with fixed header and scrollable content */}
      <div class="flex-1 overflow-hidden flex flex-col">
        {/* Fixed action bar */}
        <div class="bg-slate-800 p-4 shadow-md">
          <div class="container mx-auto flex items-center">
            <button
              onClick={() => navigate('/newsfeed')}
              class="bg-slate-700 hover:bg-slate-600 text-white px-4 py-2 rounded transition-colors mr-4"
            >
              ← Back to Threads
            </button>
            <h1 class="text-2xl font-bold">{threadTopic || 'Thread'}</h1>
          </div>
        </div>
        
        {/* Scrollable content area */}
        <div class="flex-1 overflow-y-auto p-4">
          <div class="container mx-auto">
            <Show when={!isLoading()} fallback={<div class="text-center py-8">Loading messages...</div>}>
              <Show when={!error()} fallback={<div class="text-red-500">{error()}</div>}>
                <div class="bg-slate-800 rounded-lg p-4 mb-4">
                  <div class="space-y-4 mb-4">
                    <For each={messages()}>
                      {(message) => (
                        <div class="bg-slate-700 p-4 rounded-lg">
                          <div class="flex justify-between mb-2">
                            <span class="font-medium">{userService.getUserName(message.creator_id || "unknown")}</span>
                            <span class="text-slate-400 text-sm">
                              {message.created_at ? new Date(message.created_at).toLocaleString() : 'Unknown time'}
                            </span>
                          </div>
                          <p class="text-slate-200">{message.text}</p>
                          <Show when={message.image}>
                            <img 
                              src={imageUrls()[message.image!] || ''} 
                              alt="Message attachment" 
                              class="mt-2 max-w-full h-auto rounded-lg max-h-96"
                              onError={(e) => {
                                if (!imageUrls()[message.image!]) {
                                  fetchImage(message.image!).then(url => {
                                    setImageUrls(prev => ({...prev, [message.image!]: url}));
                                  });
                                }
                              }}
                            />
                          </Show>
                        </div>
                      )}
                    </For>
                  </div>
                </div>
              </Show>
            </Show>
          </div>
        </div>
        
        {/* Fixed message input area */}
        <div class="bg-slate-800 p-4 border-t border-slate-700">
          <div class="container mx-auto">
            <div class="flex items-center gap-2 border border-slate-600 rounded-lg p-2 bg-slate-700">
              <label class="cursor-pointer text-slate-400 hover:text-white transition-colors">
                <input
                  type="file"
                  accept="image/*"
                  class="hidden"
                  onChange={(e) => {
                    const file = e.currentTarget.files?.[0];
                    if (file) {
                      setSelectedImage(file);
                      setImagePreview(URL.createObjectURL(file));
                    }
                  }}
                />
                📎
              </label>
              
              <textarea
                value={newMessage()}
                onInput={(e) => setNewMessage(e.currentTarget.value)}
                onKeyDown={handleNewMessageKeyDown}
                placeholder="Type your message..."
                class="flex-1 bg-transparent text-white p-2 focus:outline-none resize-none"
                rows="2"
              />
              
              <button
                onClick={handleSend}
                disabled={isUploading() || (!newMessage().trim() && !selectedImage())}
                class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isUploading() ? 'Sending...' : 'Send'}
              </button>
            </div>
            
            <Show when={imagePreview()}>
              <div class="relative mt-2">
                <img 
                  src={imagePreview()!} 
                  alt="Preview" 
                  class="max-h-48 w-auto rounded-lg"
                />
                <button
                  onClick={() => {
                    setSelectedImage(null);
                    setImagePreview(null);
                  }}
                  class="absolute top-1 right-1 bg-red-600/80 text-white rounded-full p-1 hover:bg-red-600"
                >
                  ✕
                </button>
              </div>
            </Show>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ThreadMessages; 
import { Component, createSignal, onMount, createMemo, createEffect, For, Show } from 'solid-js';
import { useParams, useNavigate, useLocation } from '@solidjs/router';
import { ThreadsService } from '../api/services/ThreadsService';
import { MessagesResponse } from '../api/models/MessagesResponse';
import { MessageResponse } from '../api/models/MessageResponse';
import UserInfo from './UserInfo';
import { ThreadResponse } from '../api/models/ThreadResponse';

import { userService } from '../services/userService';
import { fetchImage, uploadImage } from '../utils/imageUtils';

const ThreadMessages: Component = () => {
  const params = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const threadTopic = new URLSearchParams(location.search).get('thread_topic') ?? '';
  console.log("thread topic = ", threadTopic);
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
    <div class="h-screen flex flex-col bg-monk-dark overflow-hidden">
      {/* Header */}
      <div class="h-[100px] sticky top-0 bg-monk-dark/95 backdrop-blur-sm z-10 pt-4 pb-4 px-8">
        <h2 class="text-monk-cream text-2xl font-bold text-center">
          {threadTopic || "Untitled Thread"}
        </h2>
      </div>

      {/* Messages List */}
      <div class="flex-1 overflow-y-auto">
        <div class="max-w-4xl mx-auto px-8 pt-4 space-y-4">
          <For each={combinedMessages()}>
            {(message) => (
              <div class="bg-monk-mid/70 backdrop-blur-sm p-4 rounded-xl border-2 border-monk-teal/40
                         hover:border-monk-teal/60 transition-colors">
                {/* Message Content */}
                <Show when={message._id === thread()?._id}>
                  <h2 class="text-monk-cream text-xl font-bold mb-2">
                    {thread()?.topic}
                  </h2>
                </Show>
                
                <p class="text-monk-cream">{message.text}</p>
                
                <Show when={message.presigned_url}>
                  <img 
                    src={message.presigned_url!} 
                    alt="Content attachment" 
                    class="mt-2 rounded-lg max-w-full h-48 object-cover"
                  />
                </Show>

                {/* Author and Timestamp */}
                <div class="mt-2 text-monk-gray text-sm">
                  <span>
                    By {userService.getUserName(message.creator_id??"unknown")} • 
                    {message.created_at ? 
                      new Date(message.created_at).toLocaleString() : 
                      'Unknown time'}
                  </span>
                </div>
              </div>
            )}
          </For>
          <div ref={messagesEndRef} />
        </div>
      </div>

      {/* Footer */}
      <div class="h-[140px] border-t border-monk-teal/20 bg-monk-dark/95 backdrop-blur-sm">
        {/* Input Container */}
        <div class="max-w-4xl mx-auto px-8 pt-4 flex items-center gap-4">
          <button 
            onClick={() => navigate(-1)}
            class="text-monk-gray hover:text-monk-gold transition-colors flex items-center gap-2"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
            </svg>
            <span class="text-sm font-medium">Newsfeed</span>
          </button>

          {/* Combined input area */}
          <div class="flex-1 flex items-center gap-2 border-2 border-monk-gold/30 bg-monk-dark rounded-xl p-1">
            {/* File upload button */}
            <label class="cursor-pointer text-monk-gray hover:text-monk-gold transition-colors pl-2">
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
              <svg 
                class="w-6 h-6" 
                fill="none" 
                stroke="currentColor" 
                viewBox="0 0 24 24"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
              </svg>
            </label>

            {/* Text input */}
            <input
              type="text"
              value={newMessage()}
              onInput={(e) => setNewMessage(e.currentTarget.value)}
              onKeyDown={handleNewMessageKeyDown}
              class="flex-1 bg-transparent text-white p-2 focus:outline-none placeholder-monk-gray"
              placeholder="Type your message..."
            />

            {/* Image preview and send button container */}
            <div class="flex items-center gap-2">
              <Show when={imagePreview()}>
                <div class="relative">
                  <img 
                    src={imagePreview()!} 
                    alt="Preview" 
                    class="w-12 h-12 rounded-lg object-cover"
                  />
                  <button
                    onClick={() => {
                      setSelectedImage(null);
                      setImagePreview(null);
                    }}
                    class="absolute -top-1 -right-1 bg-monk-red/80 text-white rounded-full p-0.5 hover:bg-monk-red"
                  >
                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                  </button>
                </div>
              </Show>

              <button 
                onClick={handleSend}
                disabled={isUploading()}
                class="bg-monk-gold text-monk-blue px-6 py-3 rounded-lg hover:bg-monk-orange transition-colors disabled:opacity-50"
              >
                {isUploading() ? 'Sending...' : 'Send'}
              </button>
            </div>
          </div>
        </div>

        {/* UserInfo Container */}
        <div class="w-full px-0 pt-2 flex justify-start">
          <UserInfo />
        </div>

      </div>
    </div>
  );
};

export default ThreadMessages; 
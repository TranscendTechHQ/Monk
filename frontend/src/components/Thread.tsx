/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createEffect, createSignal } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import { ThreadResponse } from '../api/models/ThreadResponse';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import { Show } from 'solid-js';
import { ThreadsService } from '../api/services/ThreadsService';

import { userService } from '../services/userService';

interface ThreadProps {
  thread: ThreadResponse;
}

const [userCache, setUserCache] = createSignal<Record<string, string>>({});

// Helper function to get user name
const getUserName = (userId: string) => userCache()[userId] || "Unknown";

const Thread: Component<ThreadProps> = (props) => {
  const [imageUrl, setImageUrl] = createSignal<string | null>(null);
  const navigate = useNavigate();

  createEffect(async () => {
    if (props.thread.image) {
      try {
        const url = await ThreadsService.getDownloadUrl(props.thread.image);
        setImageUrl(url);
      } catch (error) {
        console.error('Error fetching image URL:', error);
        setImageUrl(null);
      }
    }
  });

  const handleClick = () => {
    navigate(`/thread/${props.thread._id}?thread_topic=${props.thread.topic}`);
  };

  return (
    <div 
      class="bg-monk-light rounded-xl p-4 shadow-md border-2 border-monk-teal/20
             hover:border-monk-orange/40 transition-colors cursor-pointer
             flex flex-col items-center space-y-4"
      onClick={handleClick}
    >
      {/* Topic and Text - left aligned */}
      <div class="w-full space-y-2 text-left">
        <h3 class="text-monk-cream text-lg font-bold">{props.thread.topic}</h3>
        <p class="text-slate-300 text-sm">{props.thread.text?.toString() || "No Title"}</p>
      </div>

      {/* Image */}
      <Show when={imageUrl()}>
        <img 
          src={imageUrl()!} 
          alt="Thread Image" 
          class="w-full max-w-md h-48 object-cover rounded-lg"
        />
      </Show>

      {/* Creator Info - left aligned */}
      <div class="text-slate-300 text-xs mt-2 self-start">
        <span>
          By {userService.getUserName(props.thread.creator_id??'Unknown')} • 
          {new Date(props.thread.created_at??'Unknown date').toLocaleDateString()}
        </span>
      </div>
    </div>
  );
};

export const ThreadList: Component<{ threads: ThreadsResponse }> = (props) => {
  return (
    <div class="h-full w-full flex justify-center">
      <div class="w-[70%] max-w-4xl space-y-4">
        {props.threads.threads.map((thread) => (
          <Thread thread={thread} />
        ))}
      </div>
    </div>
  );
};

export default Thread; 
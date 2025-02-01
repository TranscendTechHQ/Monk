/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createEffect, createSignal } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import { ThreadResponse } from '../api/models/ThreadResponse';
import { ThreadsResponse } from '../api/models/ThreadsResponse';

import { userService } from '../services/userService';

interface ThreadProps {
  thread: ThreadResponse;
}

const [userCache, setUserCache] = createSignal<Record<string, string>>({});

// Helper function to get user name
const getUserName = (userId: string) => userCache()[userId] || "Unknown";

const Thread: Component<ThreadProps> = (props) => {
  // Keep this commented for future debugging
  // console.log('[Thread] Rendering thread ID:', props.thread.id, 'with creator:', props.thread.creator_id);
  const navigate = useNavigate();

  const handleClick = () => {
    navigate(`/thread/${props.thread._id}?thread_topic=${props.thread.topic}`);
  };

  return (
    <div 
      class="bg-monk-light rounded-xl p-4 shadow-md border-2 border-monk-teal/20
             hover:border-monk-orange/40 transition-colors cursor-pointer"
      onClick={handleClick}
    >
      <h3 class="text-monk-cream text-lg font-bold">{props.thread.topic}</h3>
      <p class="text-slate-300">{props.thread.text?.toString() || "No Title"}</p>
      <div class="text-slate-300 text-sm">
        <span>By {userService.getUserName(props.thread.creator_id??'Unknow')} • {new Date(props.thread.created_at??'Unknown date').toLocaleDateString()}</span>
      </div>
    </div>
  );
};

export const ThreadList: Component<{ threads: ThreadsResponse }> = (props) => {
  return (
    <div class="overflow-y-auto max-h-[400px] mx-auto w-1/2">
      <div class="space-y-4">
        {props.threads.threads.map((thread) => (
          <Thread thread={thread} />
        ))}
      </div>
    </div>
  );
};

export default Thread; 
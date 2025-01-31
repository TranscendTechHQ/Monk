/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createEffect, createSignal } from 'solid-js';
import { useNavigate } from '@solidjs/router';
import { ThreadResponse } from '../api/models/ThreadResponse';
import { ThreadsResponse } from '../api/models/ThreadsResponse';
import { ThreadsService } from '../api/services/ThreadsService';
import { UserMap } from '../api/models/UserMap';
import { UserModel } from '../api/models/UserModel';

interface ThreadProps {
  thread: ThreadResponse;
}

const [userCache, setUserCache] = createSignal<Record<string, string>>({});

// Fetch all users and cache their names
createEffect(async () => {
  try {
    const users = await ThreadsService.getUsers();
    const cache = Object.entries(users.users).reduce((acc, [userId, user]) => ({
      ...acc,
      [userId]: user.name || user.email || "Anonymous"
    }), {});
    setUserCache(cache);
  } catch (err) {
    console.error('Error fetching users:', err);
  }
});

// Helper function to get user name
const getUserName = (userId: string) => userCache()[userId] || "Unknown";

const Thread: Component<ThreadProps> = (props) => {
  const navigate = useNavigate();

  const handleClick = () => {
    navigate(`/thread/${props.thread.id}`);
  };

  return (
    <div 
      class="bg-slate-700 ring-1 ring-slate-400/20 rounded-xl p-4 hover:bg-slate-600 transition-all cursor-pointer" 
      onClick={handleClick}
    >
      <h3 class="text-white text-lg font-semibold">{props.thread.content.topic || "No Topic"}</h3>
      <p class="text-slate-300">{props.thread.content.headline?.toString() || "No Title"}</p>
      <div class="text-slate-300 text-sm">
        <span>By {getUserName(props.thread.creator_id)} • {new Date(props.thread.created_at).toLocaleDateString()}</span>
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
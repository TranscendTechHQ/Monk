/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component } from 'solid-js';
import { ThreadProps } from '../models/ThreadProps';
import { useNavigate } from '@solidjs/router';

export const Thread: Component<ThreadProps> = (props) => {
  const navigate = useNavigate();

  const handleClick = () => {
    navigate(`/thread/${props._id}`);
  };

  return (
    <div 
      class="bg-slate-700 rounded-lg p-6 shadow-md cursor-pointer" 
      onClick={handleClick}
    >
      <h2 class="text-slate-100 text-lg font-medium mb-2">{props.topic || "No Topic"}</h2>
      <h3 class="text-slate-100 text-m font-medium mb-2">{props.headline || "No Title"}</h3>
      <div class="text-slate-300 text-sm">
        <span>By {props.creator.name || "Unknown"} • {new Date(props.created_at).toLocaleDateString()}</span>
      </div>
    </div>
  );
}; 
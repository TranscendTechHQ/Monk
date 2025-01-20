/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component } from 'solid-js';
import { ThreadMetaData } from '../api';

interface ThreadProps extends ThreadMetaData {
  // Additional props if needed
}

export const Thread: Component<ThreadProps> = (props) => {
  return (
    <div class="bg-slate-700 rounded-lg p-6 shadow-md">
      <h3 class="text-slate-100 text-lg font-medium mb-2">{props.headline || "No Title"}</h3>
      <div class="text-slate-300 text-sm">
        <span>By {props.creator.name || "Unknown"} • {new Date(props.created_at).toLocaleDateString()}</span>
      </div>
    </div>
  );
}; 
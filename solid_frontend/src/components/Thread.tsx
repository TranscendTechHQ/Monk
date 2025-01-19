/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component } from 'solid-js';
import type { Thread as ThreadType } from '../api/client';
import styles from './Thread.module.css';

interface ThreadProps {
  thread: ThreadType;
}

export const Thread: Component<ThreadProps> = (props) => {
  return (
    <div class={styles.thread}>
      {props.thread.blocks.map((block) => (
        <div class={styles.block}>
          <p>{block.content}</p>
        </div>
      ))}
      <div class={styles.metadata}>
        <span>{new Date(props.thread.created_at).toLocaleDateString()}</span>
      </div>
    </div>
  );
}; 
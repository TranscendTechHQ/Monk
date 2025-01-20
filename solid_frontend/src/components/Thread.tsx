/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component } from 'solid-js';
import { ThreadMetaData, UserModel } from '../api';
import styles from './Thread.module.css';

interface ThreadProps extends ThreadMetaData {
  // Additional props if needed
}

export const Thread: Component<ThreadProps> = (props) => {
  return (
    <div class={styles.thread}>
      <h3>{props.headline || props.topic}</h3>
      <div class={styles.metadata}>
        <span>By {props.creator.name} • {new Date(props.created_at).toLocaleDateString()}</span>
      </div>
    </div>
  );
}; 
/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createSignal } from 'solid-js';
import { ApiClient } from '../api/client';
import styles from './ThreadComposer.module.css';

interface ThreadComposerProps {
  onThreadCreated: () => void;
}

export const ThreadComposer: Component<ThreadComposerProps> = (props) => {
  const [blocks, setBlocks] = createSignal([{ content: '' }]);

  const addBlock = () => {
    setBlocks([...blocks(), { content: '' }]);
  };

  const updateBlock = (index: number, content: string) => {
    const newBlocks = blocks().map((block, i) => 
      i === index ? { content } : block
    );
    setBlocks(newBlocks);
  };

  const handleSubmit = async (e: Event) => {
    e.preventDefault();
    try {
      await ApiClient.createThread(blocks());
      setBlocks([{ content: '' }]);
      props.onThreadCreated();
    } catch (error) {
      console.error('Failed to create thread:', error);
    }
  };

  return (
    <form class={styles.composer} onSubmit={handleSubmit}>
      {blocks().map((block, index) => (
        <textarea
          value={block.content}
          onInput={(e) => updateBlock(index, e.currentTarget.value)}
          placeholder={index === 0 ? "What's happening?" : "Add to thread..."}
        />
      ))}
      <div class={styles.actions}>
        <button type="button" onClick={addBlock}>Add Block</button>
        <button type="submit">Post Thread</button>
      </div>
    </form>
  );
}; 
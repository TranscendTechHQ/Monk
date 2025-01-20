/*
 *   Copyright (c) 2025 
 *   All rights reserved.
 */

import { Component, createSignal, createEffect, For } from 'solid-js';

import { Thread } from './components/Thread';
import { ThreadComposer } from './components/ThreadComposer';
import styles from './App.module.css';
import { ThreadsService } from './api/services/ThreadsService';
import { OpenAPI } from './api/core/OpenAPI';
import { ThreadMetaData, ThreadsMetaData } from './api';
OpenAPI.BASE = 'http://localhost:8001';


const App: Component = () => {
  const [threads, setThreads] = createSignal<ThreadsMetaData>();
  const [isLoading, setIsLoading] = createSignal(true);
  const [error, setError] = createSignal<string | null>(null);

  const fetchThreads = async () => {
    try {
      setIsLoading(true);
      const userInfo = await ThreadsService.allUsersUserGet();
      console.log(userInfo);
      const fetchedThreads = await ThreadsService.filterNewsfeedGet();
      setThreads(fetchedThreads);
      setError(null);
    } catch (err) {
      setError('Failed to load threads. Please try again later.');
      console.error('Error fetching threads:', err);
    } finally {
      setIsLoading(false);
    }
  };

  // Fetch threads on component mount
  createEffect(() => {
    fetchThreads();
  });

  return (
    <div class={styles.App}>
      <header class={styles.header}>
        <h1>Thread Feed</h1>
      </header>

      <main class={styles.main}>
        

        <section class={styles.feed}>
          <h2>All Threads</h2>
          
          // TODO: Add threads to the feed
          {isLoading() ? (
            <div class={styles.loading}>Loading threads...</div>
          ) : error() ? (
            <div class={styles.error}>{error()}</div>
          ) : (
            <For each={threads()?.metadata}>
              {(thread: ThreadMetaData) => (
                <Thread 
                  {...thread}
                />
              )}
            </For>
          )}
        </section>
      </main>
    </div>
  );
};

export default App;
 
import { ThreadsService } from '../api/services/ThreadsService';
import { UserMap } from '../api/models/UserMap';

let userCache: Record<string, string> = {};

// Initialize user cache
export async function initUserCache() {
  try {
    const users = await ThreadsService.getUsers();
    userCache = Object.entries(users.users).reduce((acc, [userId, user]) => ({
      ...acc,
      [userId]: user.name || user.email || "Anonymous"
    }), {});
  } catch (err) {
    console.error('Error initializing user cache:', err);
  }
}

// Get user name from cache
export function getUserName(userId: string): string {
  return userCache[userId] || "Unknown";
} 